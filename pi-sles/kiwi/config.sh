#!/bin/bash
# vim: sw=4 et
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Activate services
#--------------------------------------
suseInsertService sshd
suseInsertService boot.device-mapper
suseInsertService ntpd
suseInsertService NetworkManager
suseRemoveService avahi-dnsconfd
suseRemoveService avahi-daemon

#==========================================
# remove unneeded packages
#------------------------------------------
suseRemovePackagesMarkedForDeletion

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

#======================================
# Set sensible defaults
#--------------------------------------

baseUpdateSysConfig /etc/sysconfig/clock HWCLOCK "-u"
baseUpdateSysConfig /etc/sysconfig/clock TIMEZONE UTC
echo 'DEFAULT_TIMEZONE="UTC"' >> /etc/sysconfig/clock
baseUpdateSysConfig /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME no
baseUpdateSysConfig /etc/sysconfig/network/dhcp WRITE_HOSTNAME_TO_HOSTS no

#==========================================
# remove unneeded kernel files
#------------------------------------------
# Stripkernel renames the image which breaks
# 2nd boot
# suseStripKernel

#==========================================
# dirs needed by kiwi for subvolumes
#------------------------------------------
mkdir -p /var/lib/mailman /var/lib/mariadb /var/lib/mysql /var/lib/named /var/lib/pgsql /var/lib/libvirt/images

#======================================
# remove unneeded firmware files
#--------------------------------------
suseStripFirmware

if ! rpmqpack | grep -q vim-enhanced; then
    #======================================
    # only basic version of vim is
    # installed; no syntax highlighting
    #--------------------------------------
    sed -i -e's/^syntax on/" syntax on/' /etc/vimrc
fi

#======================================
# Import GPG Key
#
t=$(mktemp)
cat - <<EOF > $t
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.15 (GNU/Linux)

mQENBEkUTD8BCADWLy5d5IpJedHQQSXkC1VK/oAZlJEeBVpSZjMCn8LiHaI9Wq3G
3Vp6wvsP1b3kssJGzVFNctdXt5tjvOLxvrEfRJuGfqHTKILByqLzkeyWawbFNfSQ
93/8OunfSTXC1Sx3hgsNXQuOrNVKrDAQUqT620/jj94xNIg09bLSxsjN6EeTvyiO
mtE9H1J03o9tY6meNL/gcQhxBvwuo205np0JojYBP0pOfN8l9hnIOLkA0yu4ZXig
oKOVmf4iTjX4NImIWldT+UaWTO18NWcCrujtgHueytwYLBNV5N0oJIP2VYuLZfSD
VYuPllv7c6O2UEOXJsdbQaVuzU1HLocDyipnABEBAAG0NG9wZW5TVVNFIFByb2pl
Y3QgU2lnbmluZyBLZXkgPG9wZW5zdXNlQG9wZW5zdXNlLm9yZz6JATwEEwECACYC
GwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAUCU2dN1AUJHR8ElQAKCRC4iy/UPb3C
hGQrB/9teCZ3Nt8vHE0SC5NmYMAE1Spcjkzx6M4r4C70AVTMEQh/8BvgmwkKP/qI
CWo2vC1hMXRgLg/TnTtFDq7kW+mHsCXmf5OLh2qOWCKi55Vitlf6bmH7n+h34Sha
Ei8gAObSpZSF8BzPGl6v0QmEaGKM3O1oUbbB3Z8i6w21CTg7dbU5vGR8Yhi9rNtr
hqrPS+q2yftjNbsODagaOUb85ESfQGx/LqoMePD+7MqGpAXjKMZqsEDP0TbxTwSk
4UKnF4zFCYHPLK3y/hSH5SEJwwPY11l6JGdC1Ue8Zzaj7f//axUs/hTC0UZaEE+a
5v4gbqOcigKaFs9Lc3Bj8b/lE10Y
=i2TA
-----END PGP PUBLIC KEY BLOCK-----
EOF
rpm --import $t
rm -f $t

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

#======================================
# Invoke grub2-install
#--------------------------------------

case $kiwi_iname in
  *efi|*.aarch64-rootfs|*vexpress64|*mustang|*thunderx|*seattle)
    [ -x /usr/sbin/grub2-install ] && {
        /usr/sbin/grub2-install || :
    }
    ;;
esac

case "$kiwi_iname" in
  *-raspberrypi3_aarch64)
    #======================================
    # Add xorg config with modesetting, as
    # fbdev doesn't support 3d (and is broken)
    #--------------------------------------
    mkdir -p /etc/X11/xorg.conf.d/
    cat > /etc/X11/xorg.conf.d/20-kms.conf <<-EOF
	Section "Device"
	    Identifier "kms gfx"
	    Driver "modesetting"
	    Option "AccelMethod" "none"
	EndSection
	EOF
    ;;
  *)
    #======================================
    # Add xorg config with fbdev
    #--------------------------------------
    mkdir -p /etc/X11/xorg.conf.d/
    cat > /etc/X11/xorg.conf.d/20-fbdev.conf <<-EOF
	Section "Device"
	    Identifier "fb gfx"
	    Driver "fbdev"
	    Option "fb" "/dev/fb0"
	EndSection
	EOF
    ;;
esac

#======================================
# Configure system for E20 usage
#--------------------------------------
# XXX only do for E20 image types
if [[ "$kiwi_iname" == *"E20-"* ]]; then
	baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER lightdm
	cat >> /etc/sysconfig/windowmanager <<EOF
## Path:        Desktop/Window manager
## Description:
## Type:        string(gnome,kde4,kde,lxde,xfce,twm,icewm)
## Default:     xfce
## Config:      profiles,kde,susewm
#
# Here you can set the default window manager (kde, fvwm, ...)
# changes here require at least a re-login
DEFAULT_WM="enlightenment"
EOF
	# We want to start in gfx mode
	baseSetRunlevel 5
	suseConfig
fi

#======================================
# Configure system for LXQT usage
#--------------------------------------
# XXX only do for LXQT image types
if [[ "$kiwi_iname" == *"LXQT-"* ]]; then
	baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER lightdm
	cat >> /etc/sysconfig/windowmanager <<EOF
## Path:        Desktop/Window manager
## Description:
## Type:        string(gnome,kde4,kde,lxde,xfce,twm,icewm)
## Default:     xfce
## Config:      profiles,kde,susewm
#
# Here you can set the default window manager (kde, fvwm, ...)
# changes here require at least a re-login
DEFAULT_WM="lxqt"
EOF
	# We want to start in gfx mode
	baseSetRunlevel 5
	suseConfig
fi

#======================================
# Configure system for XFCE usage
#--------------------------------------
# XXX only do for XFCE image types
if [[ "$kiwi_iname" == *"XFCE-"* ]]; then
	baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER lightdm
	cat >> /etc/sysconfig/windowmanager <<EOF
## Path:        Desktop/Window manager
## Description:
## Type:        string(gnome,kde4,kde,lxde,xfce,twm,icewm)
## Default:     xfce
## Config:      profiles,kde,susewm
#
# Here you can set the default window manager (kde, fvwm, ...)
# changes here require at least a re-login
DEFAULT_WM="xfce"
EOF
	# We want to start in gfx mode
	baseSetRunlevel 5
	suseConfig
fi

#======================================
# Configure system for IceWM usage
#--------------------------------------
# XXX only do for X11 image types
if [[ "$kiwi_iname" == *"X11-"* ]]; then
	baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER xdm
	baseUpdateSysConfig /etc/sysconfig/windowmanager DEFAULT_WM icewm

	# We want to start in gfx mode
	baseSetRunlevel 5
	suseConfig
fi

#======================================
# Add tty devices to securetty
#--------------------------------------
# XXX should be target specific
cat >> /etc/securetty <<EOF
ttyO0
ttyO2
ttyAMA0
ttyAMA2
ttymxc0
ttymxc1
EOF

#======================================
# Bring up eth device automatically
#--------------------------------------
mkdir -p /etc/sysconfig/network/
case "$kiwi_iname" in
    *-m400)
	cat > /etc/sysconfig/network/ifcfg-enp1s0 <<-EOF
	BOOTPROTO='dhcp'
	MTU=''
	REMOTE_IPADDR=''
	STARTMODE='onboot'
	EOF
	;;
    *-raspberrypi3_aarch64)
        # Do not interfere with DHCP setup in yast firstboot
        ;;
    *)
	# XXX extend to more boards
	cat > /etc/sysconfig/network/ifcfg-eth0 <<-EOF
	BOOTPROTO='dhcp'
	MTU=''
	REMOTE_IPADDR=''
	STARTMODE='onboot'
	EOF
	;;
esac

#======================================
# Configure ntp
#--------------------------------------

# tell e2fsck to ignore the time differences
cat > /etc/e2fsck.conf <<EOF
[options]
broken_system_clock=true
EOF

case "$kiwi_iname" in
  *-raspberrypi3_aarch64)
    # Do not interfere with NTP setup in yast firstboot
    ;;
  *)
    for i in 0 1 2 3; do
        echo "server $i.opensuse.pool.ntp.org iburst" >> /etc/ntp.conf
    done
    ;;
esac

#======================================
# Trigger yast2-firstboot on first boot
#--------------------------------------
# XXX It breaks more than it helps for now, just disable it
case "$kiwi_iname" in
  *-raspberrypi3_aarch64)
    touch /var/lib/YaST2/reconfig_system
    # Use our own workflow
    baseUpdateSysConfig /etc/sysconfig/firstboot FIRSTBOOT_CONTROL_FILE /etc/YaST2/firstboot-rpi3.xml
    ;;
esac

# Link firmware in place (REMOVE ONCE FIXED IN bcm43xx-firmware)
case "$kiwi_iname" in
  *-raspberrypi3)
    ln -sf brcmfmac43430-sdio-raspberrypi3b.txt /lib/firmware/brcm/brcmfmac43430-sdio.txt
    ;;
  *-raspberrypi3_aarch64)
    ln -sf brcmfmac43430-sdio-raspberrypi3b.txt /lib/firmware/brcm/brcmfmac43430-sdio.txt
    ;;
esac

#======================================
# Load panel-tfp410 before omapdrm
#---
if [[ "$kiwi_iname" == *"-beagle" || "$kiwi_iname" == *"-panda" ]]; then
    cat > /etc/modprobe.d/50-omapdrm.conf <<EOF
# Ensure that panel-tfp410 is loaded before omapdrm
softdep omapdrm pre: panel-tfp410
EOF
fi

#======================================
# Load cros-ec-keyb (on board keyboard) for chromebook (snow)
#---
if [[ "$kiwi_iname" == *"-chromebook" ]]; then
    cat > /etc/modules-load.d/cros-ec-keyb.conf <<EOF
# Load cros-ec-keyb (on board keyboard)
cros-ec-keyb
EOF
fi

#======================================
# Ignore HDMI hotplug on RPi3
#---
if [[ "$kiwi_iname" == *"-raspberrypi3" || "$kiwi_iname" == *"-raspberrypi3_aarch64" ]]; then
    cat > /etc/modprobe.d/50-rpi3.conf <<EOF
# No HDMI hotplug available
options drm_kms_helper poll=0
EOF
fi

#======================================
# Load useful modules not auto-loaded for i.MX6 boards (SabreLite)
#---
if [[ "$kiwi_iname" == *"-sabrelite" ]]; then
    cat > /etc/modules-load.d/imx6.conf <<EOF
# Load imx_ipuv3_crtc to get HDMI output working
imx_ipuv3_crtc
# Load imx6q-cpufreq to make use of cpufreq
imx6q-cpufreq
EOF
fi

#======================================
# Import trusted keys
#--------------------------------------
for i in /usr/lib/rpm/gnupg/keys/gpg-pubkey*asc; do
    # importing can fail if it already exists
    rpm --import $i || true
done

#======================================
# Add alsa config file for beagleboard
#---
if [[ "$kiwi_iname" == *"-beagle" ]]; then
cat > /var/lib/alsa/asound.state <<EOF
state.omap3beagle {
	control.1 {
		iface MIXER
		name 'Codec Operation Mode'
		value 'Option 1 (audio)'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Option 2 (voice/audio)'
			item.1 'Option 1 (audio)'
		}
	}
	control.2 {
		iface MIXER
		name 'DAC1 Digital Fine Playback Volume'
		value.0 63
		value.1 63
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 63'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.3 {
		iface MIXER
		name 'DAC2 Digital Fine Playback Volume'
		value.0 63
		value.1 63
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 63'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.4 {
		iface MIXER
		name 'DAC1 Digital Coarse Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 2'
			dbmin 0
			dbmax 1200
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.5 {
		iface MIXER
		name 'DAC2 Digital Coarse Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 2'
			dbmin 0
			dbmax 1200
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.6 {
		iface MIXER
		name 'DAC1 Analog Playback Volume'
		value.0 12
		value.1 12
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 18'
			dbmin -2400
			dbmax 1200
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.7 {
		iface MIXER
		name 'DAC2 Analog Playback Volume'
		value.0 12
		value.1 12
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 18'
			dbmin -2400
			dbmax 1200
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.8 {
		iface MIXER
		name 'DAC1 Analog Playback Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.9 {
		iface MIXER
		name 'DAC2 Analog Playback Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.10 {
		iface MIXER
		name 'DAC Voice Digital Downlink Volume'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 49'
			dbmin -9999999
			dbmax 1200
			dbvalue.0 -9999999
		}
	}
	control.11 {
		iface MIXER
		name 'DAC Voice Analog Downlink Volume'
		value 12
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 18'
			dbmin -2400
			dbmax 1200
			dbvalue.0 0
		}
	}
	control.12 {
		iface MIXER
		name 'DAC Voice Analog Downlink Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.13 {
		iface MIXER
		name 'PreDriv Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 3'
			dbmin -9999999
			dbmax 600
			dbvalue.0 -9999999
			dbvalue.1 -9999999
		}
	}
	control.14 {
		iface MIXER
		name 'Headset Playback Volume'
		value.0 3
		value.1 3
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 3'
			dbmin -9999999
			dbmax 600
			dbvalue.0 600
			dbvalue.1 600
		}
	}
	control.15 {
		iface MIXER
		name 'Carkit Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 3'
			dbmin -9999999
			dbmax 600
			dbvalue.0 -9999999
			dbvalue.1 -9999999
		}
	}
	control.16 {
		iface MIXER
		name 'Earpiece Playback Volume'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 3'
			dbmin -9999999
			dbmax 1200
			dbvalue.0 -9999999
		}
	}
	control.17 {
		iface MIXER
		name 'TX1 Digital Capture Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin 0
			dbmax 3100
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.18 {
		iface MIXER
		name 'TX2 Digital Capture Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin 0
			dbmax 3100
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.19 {
		iface MIXER
		name 'Analog Capture Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 5'
			dbmin 0
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.20 {
		iface MIXER
		name 'AVADC Clock Priority'
		value 'HiFi high priority'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Voice high priority'
			item.1 'HiFi high priority'
		}
	}
	control.21 {
		iface MIXER
		name 'HS ramp delay'
		value '27/20/14 ms'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 '27/20/14 ms'
			item.1 '55/40/27 ms'
			item.2 '109/81/55 ms'
			item.3 '218/161/109 ms'
			item.4 '437/323/218 ms'
			item.5 '874/645/437 ms'
			item.6 '1748/1291/874 ms'
			item.7 '3495/2581/1748 ms'
		}
	}
	control.22 {
		iface MIXER
		name 'Vibra H-bridge mode'
		value 'Audio data MSB'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Vibra H-bridge direction'
			item.1 'Audio data MSB'
		}
	}
	control.23 {
		iface MIXER
		name 'Vibra H-bridge direction'
		value 'Positive polarity'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Positive polarity'
			item.1 'Negative polarity'
		}
	}
	control.24 {
		iface MIXER
		name 'Digimic LR Swap'
		value 'Not swapped'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Not swapped'
			item.1 Swapped
		}
	}
	control.25 {
		iface MIXER
		name 'Analog Right Sub Mic Capture Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.26 {
		iface MIXER
		name 'Analog Right AUXR Capture Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.27 {
		iface MIXER
		name 'Analog Left Main Mic Capture Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.28 {
		iface MIXER
		name 'Analog Left Headset Mic Capture Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.29 {
		iface MIXER
		name 'Analog Left AUXL Capture Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.30 {
		iface MIXER
		name 'Analog Left Carkit Mic Capture Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.31 {
		iface MIXER
		name 'TX2 Capture Route'
		value Analog
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Analog
			item.1 Digimic1
		}
	}
	control.32 {
		iface MIXER
		name 'TX1 Capture Route'
		value Analog
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Analog
			item.1 Digimic0
		}
	}
	control.33 {
		iface MIXER
		name 'Vibra Route'
		value 'Local vibrator'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Local vibrator'
			item.1 Audio
		}
	}
	control.34 {
		iface MIXER
		name 'Vibra Mux'
		value AudioR2
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 AudioL1
			item.1 AudioR1
			item.2 AudioL2
			item.3 AudioR2
		}
	}
	control.35 {
		iface MIXER
		name 'HandsfreeR Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.36 {
		iface MIXER
		name 'HandsfreeR Mux'
		value Voice
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Voice
			item.1 AudioR1
			item.2 AudioR2
			item.3 AudioL2
		}
	}
	control.37 {
		iface MIXER
		name 'HandsfreeL Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.38 {
		iface MIXER
		name 'HandsfreeL Mux'
		value Voice
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Voice
			item.1 AudioL1
			item.2 AudioL2
			item.3 AudioR2
		}
	}
	control.39 {
		iface MIXER
		name 'CarkitR Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.40 {
		iface MIXER
		name 'CarkitR Mixer AudioR1'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.41 {
		iface MIXER
		name 'CarkitR Mixer AudioR2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.42 {
		iface MIXER
		name 'CarkitL Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.43 {
		iface MIXER
		name 'CarkitL Mixer AudioL1'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.44 {
		iface MIXER
		name 'CarkitL Mixer AudioL2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.45 {
		iface MIXER
		name 'HeadsetR Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.46 {
		iface MIXER
		name 'HeadsetR Mixer AudioR1'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.47 {
		iface MIXER
		name 'HeadsetR Mixer AudioR2'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.48 {
		iface MIXER
		name 'HeadsetL Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.49 {
		iface MIXER
		name 'HeadsetL Mixer AudioL1'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.50 {
		iface MIXER
		name 'HeadsetL Mixer AudioL2'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.51 {
		iface MIXER
		name 'PredriveR Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.52 {
		iface MIXER
		name 'PredriveR Mixer AudioR1'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.53 {
		iface MIXER
		name 'PredriveR Mixer AudioR2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.54 {
		iface MIXER
		name 'PredriveR Mixer AudioL2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.55 {
		iface MIXER
		name 'PredriveL Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.56 {
		iface MIXER
		name 'PredriveL Mixer AudioL1'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.57 {
		iface MIXER
		name 'PredriveL Mixer AudioL2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.58 {
		iface MIXER
		name 'PredriveL Mixer AudioR2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.59 {
		iface MIXER
		name 'Earpiece Mixer Voice'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.60 {
		iface MIXER
		name 'Earpiece Mixer AudioL1'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.61 {
		iface MIXER
		name 'Earpiece Mixer AudioL2'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.62 {
		iface MIXER
		name 'Earpiece Mixer AudioR1'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.63 {
		iface MIXER
		name 'Voice Digital Loopback Volume'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 41'
			dbmin -9999999
			dbmax -1000
			dbvalue.0 -9999999
		}
	}
	control.64 {
		iface MIXER
		name 'Right Digital Loopback Volume'
		value 4
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 7'
			dbmin -9999999
			dbmax 0
			dbvalue.0 -1800
		}
	}
	control.65 {
		iface MIXER
		name 'Left Digital Loopback Volume'
		value 4
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 7'
			dbmin -9999999
			dbmax 0
			dbvalue.0 -1800
		}
	}
	control.66 {
		iface MIXER
		name 'Voice Analog Loopback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.67 {
		iface MIXER
		name 'Left2 Analog Loopback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.68 {
		iface MIXER
		name 'Right2 Analog Loopback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.69 {
		iface MIXER
		name 'Left1 Analog Loopback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.70 {
		iface MIXER
		name 'Right1 Analog Loopback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
}
EOF
fi

#======================================
# Initrd fixes (for 2nd boot only. 1st boot modules are handled by *.kiwi files)
#--------------------------------------
if [[ "$kiwi_iname" == *"-mustang" ]]; then
    # Old initrd config file
    sed -i 's/INITRD_MODULES="/INITRD_MODULES="phy_xgene ahci_xgene /' /etc/sysconfig/kernel
    # New dracut (initrd) config file
    echo 'add_drivers+=" phy_xgene ahci_xgene "' >  /etc/dracut.conf.d/mustang_modules.conf
fi

if [[ "$kiwi_iname" == *"-arndale" ]] || [[ "$kiwi_iname" == *"-chromebook" ]]; then
    # Old initrd config file
    sed -i 's/INITRD_MODULES="/INITRD_MODULES="i2c-exynos5 tps65090-regulator sdhci-pltfm sdhci-s3c mmc_core mmc_block dwc3-exynos dw_dmac dw_mmc dw_wdt dw_mmc-exynos dw_mmc-pltfm dw_dmac dw_dmac_core usbcore usb-common ohci-hcd ohci-exynos ehci-hcd ehci-exynos phy-exynos-dp-video phy-exynos-mipi-video /' /etc/sysconfig/kernel
    # New dracut (initrd) config file
    echo 'add_drivers+=" i2c-exynos5 tps65090-regulator sdhci-pltfm sdhci-s3c mmc_core mmc_block dwc3-exynos dw_dmac dw_mmc dw_wdt dw_mmc-exynos dw_mmc-pltfm dw_dmac dw_dmac_core usb-storage uas usbcore usb-common ehci-hcd ehci-exynos phy-exynos-usb2 phy-generic phy-exynos-dp-video phy-exynos-mipi-video "' >  /etc/dracut.conf.d/exynos_modules.conf
fi

# Arndale crashes when ehci and xhci are loaded very quickly in one go
# Since it doesn't support xhci anyway, lets blacklist it
if [[ "$kiwi_iname" == *"-arndale" ]] ; then
    echo "install xhci_hcd /bin/true" > /etc/modprobe.d/90-blacklist-xhci.conf
    echo "install ohci-exynos /bin/true" >> /etc/modprobe.d/90-blacklist-xhci.conf
    echo "install exynosdrm /bin/true" >> /etc/modprobe.d/90-blacklist-xhci.conf
fi

if [[ "$kiwi_iname" == *"-chromebook" ]]; then
    # Force load of modules needed to get display working fine
    echo 'force_drivers+=" cros_ec_devs ptn3460 pwm-samsung "' >> /etc/dracut.conf.d/exynos_modules.conf
fi

if [[ "$kiwi_iname" == *"-beaglebone" ]]; then
    # New dracut (initrd) config file
    echo 'add_drivers+=" tda998x "' > /etc/dracut.conf.d/beagleboneblack_modules.conf
fi

if [[ "$kiwi_iname" == *"-cubietruck" ]] || [[ "$kiwi_iname" == *"-cubieboard"*	]] || [[ "$kiwi_iname" == *"olinuxino"* ]]; then
    # Old initrd config file
    sed -i 's/INITRD_MODULES="/INITRD_MODULES="sunxi-mmc /' /etc/sysconfig/kernel
    # New dracut (initrd) config file
    echo 'add_drivers+=" sunxi-mmc "' >  /etc/dracut.conf.d/sunxi_modules.conf
fi

if [[ "$kiwi_iname" == *"-sabrelite" ]]; then
    # New dracut (initrd) config file
    echo 'add_drivers+=" ahci_imx imxdrm imx_ipuv3_crtc imx_ldb "' >  /etc/dracut.conf.d/sabrelite_modules.conf
fi

if [[ "$kiwi_iname" == *"-raspberrypi" ]]; then
    echo 'add_drivers+=" sdhci_bcm2835 bcm2835_dma "' >  /etc/dracut.conf.d/raspberrypi_modules.conf
fi

if [[ "$kiwi_iname" == *"-raspberrypi2" ]]; then
    echo 'add_drivers+=" sdhci_bcm2835 bcm2835_dma mmc_block "' >  /etc/dracut.conf.d/raspberrypi_modules.conf
fi

if [[ "$kiwi_iname" == *"-raspberrypi3" ]]; then
    echo 'add_drivers+=" sdhci_bcm2835 bcm2835_dma mmc_block "' >  /etc/dracut.conf.d/raspberrypi_modules.conf
fi

if [[ "$kiwi_iname" == *"-raspberrypi3_aarch64" ]]; then
    echo -e 'add_drivers+=" bcm2835-sdhost bcm2835_dma mmc_block "\nomit_drivers+=" sdhci-iproc "' >  /etc/dracut.conf.d/raspberrypi_modules.conf
fi

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
