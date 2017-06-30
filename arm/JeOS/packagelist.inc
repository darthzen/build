<!-- Base packages -->
<package name="aaa_base-extras"/>
<package name="acl"/>
<package name="alsa"/>
<package name="audit"/>
<package name="bluez"/>
<package name="branding-openSUSE"/>
#ifdef USE_BTRFS
<package name="btrfsprogs"/>
#endif
<package name="ca-certificates"/>
<package name="ca-certificates-mozilla"/>
<package name="cracklib-dict-full"/>
<package name="dracut"/>
<package name="e2fsprogs"/>
<package name="elfutils"/>
<package name="filesystem"/>
<package name="fipscheck" />
<package name="gettext-runtime"/><!-- Do not use gettext-runtime-mini-->
<package name="gio-branding-openSUSE"/>
<package name="glibc-locale"/>
<package name="gpg2"/>
#ifdef USE_EFI
<package name="gptfdisk" bootinclude="true"/>
<package name="grub2" bootinclude="true"/>
<package name="grub2-branding-openSUSE" bootinclude="true"/>
#if IS_ARCH_aarch64
<package name="grub2-arm64-efi" bootinclude="true"/>
#elif IS_ARCH_x86_64
<package name="grub2-x86_64-efi" bootinclude="true"/>
#else
<package name="grub2-arm-efi" bootinclude="true"/>
#endif
#endif
<!--<package name="gvfs-common"/> -->
<package name="ifplugd"/>
<package name="insserv-compat"/>
<package name="iproute2"/>
<package name="iputils"/>
<package name="iw"/>
<package name="kernel-firmware"/>
<package name="kmod-compat"/>
<package name="krb5"/><!-- Do not use krb5-mini -->
<package name="less"/>
<package name="libudev1"/><!-- Do not use libudev-mini1 -->
<package name="libyui-ncurses-pkg7"/>
<package name="lvm2"/>
<package name="ncurses-utils"/>
<package name="net-tools"/>
<package name="net-tools-deprecated"/>
<!-- we need to keep our time in sync, because there is no RTC -->
<package name="ntp"/>
<package name="openssh"/>
<package name="openSUSE-build-key"/>
<package name="openSUSE-release"/>
<!-- <package name="openSUSE-release-ftp"/> -->
<package name="pkg-config"/>
<package name="python-base"/>
#if IS_ARCH_armv6
<package name="qemu-linux-user-arm" bootinclude="true"/>
#endif
<package name="sg3_utils"/>
<package name="shadow"/>
<package name="sudo"/>
<package name="SuSEfirewall2"/>
<package name="sysconfig"/>
<package name="sysconfig-netconfig"/>
<package name="system-group-hardware" bootinclude="true"/>
<package name="system-user-lp" bootinclude="true"/>
<package name="systemd"/> <!-- avoid using systemd-mini -->
<package name="systemd-presets-branding-openSUSE" />
<package name="systemd-sysvinit"/>
<package name="systemd-logger"/>
<package name="timezone"/>
#ifndef USE_EFI
<package name="u-boot-tools"/>
#endif
#if IS_FLAVOR_socfpgade0nanosoc
<package name="u-boot-tools"/>
#endif
<package name="udev"/>
<package name="usbutils"/>
<package name="util-linux-systemd"/>
<package name="vim"/>
<package name="wget"/>
<package name="which"/>
<package name="wicked"/>
<package name="wicked-service"/>
<package name="wireless-tools"/>
<package name="wpa_supplicant"/>
<package name="yast2-firewall"/>
<package name="yast2-firstboot"/>
<!-- additional yast modules needed by firstboot -->
<package name="yast2-users"/>
<package name="zypper"/>
#if IS_FLAVOR_panda || IS_FLAVOR_beagle
<package name="libdrm_omap1"/>
#endif
<!-- Base: multiple choices -->
<package name="libffi7"/>
<package name="libgcc_s1"/>
<package name="libgomp1"/>
<package name="libsystemd0"/> <!-- avoid using libsystemd0-mini -->
<package name="unzip"/>
<package name="ruby2.2-rubygem-ruby-dbus" /> <!-- needed by yast2-storage -->
<package name="ruby2.2-rubygem-gem2rpm" /> <!-- needed by ruby-common -->
<package name="ruby2.2-rubygem-cfa" /> <!-- needed by yast2 -->
<package name="ruby2.2-rubygem-cheetah" /> <!-- needed by yast2 -->
<package name="ruby2.2-rubygem-fast_gettext" /> <!-- needed by yast2 -->

#ifdef USE_DEVEL_PACKAGES
<package name="patterns-base-base"/>
<package name="patterns-devel-C-C++-devel_C_C++" />
<package name="patterns-devel-base-devel_basis" />
<package name="patterns-devel-base-devel_kernel" />
<package name="patterns-server-kvm_server" />
<!-- have choice .. -->
<package name="libatomic1" />
<package name="libitm1" />
<package name="libubsan0" />
<package name="tcsh" />
<package name="tack" />
#endif

#if (IMAGE_TYPE == TYPE_X11) || (IMAGE_TYPE == TYPE_E20) || (IMAGE_TYPE == TYPE_XFCE) || (IMAGE_TYPE == TYPE_LXQT)
<!-- Common packages for E20, LXQT and XFCE -->
<package name="ImageMagick"/>
<package name="Mesa"/>
<package name="MozillaFirefox"/>
<package name="PackageKit-gstreamer-plugin"/>
<package name="a2ps"/>
<!--<package name="acpica"/>
<package name="acpid"/> -->
<package name="alsa-oss"/>
<package name="alsa-plugins"/>
<package name="alsa-utils"/>
<package name="appres"/>
<package name="attr"/>
<package name="autofs"/>
<package name="avahi"/>
<package name="avahi-lang"/>
<package name="bdftopcf"/>
<package name="beforelight"/>
<package name="bind-utils"/>
<package name="bitmap"/>
<package name="bzip2"/>
<package name="cantarell-fonts"/>
<package name="cdrdao"/>
<package name="cdrkit-cdrtools-compat"/>
<package name="cifs-utils"/>
<package name="command-not-found"/>
<package name="coreutils"/>
<package name="cpio"/>
<package name="cron"/>
<package name="cronie"/>
<package name="cryptsetup"/>
<package name="cups"/>
<package name="cups-client"/>
<package name="curl"/>
<package name="cyrus-sasl"/>
<package name="cyrus-sasl-crammd5"/>
<package name="cyrus-sasl-digestmd5"/>
<package name="cyrus-sasl-gssapi"/>
<package name="cyrus-sasl-plain"/>
<package name="dbus-1-python"/>
<package name="dbus-1-x11"/>
<package name="dejavu"/>
<package name="deltarpm"/>
<package name="desktop-data"/>
<package name="desktop-data-openSUSE"/>
<package name="desktop-file-utils"/>
<package name="dhcp-client"/>
<package name="diffutils"/>
<package name="dirmngr"/>
<package name="distribution-release"/>
<!--<package name="dmidecode"/> -->
<package name="dmraid"/>
<package name="dmz-icon-theme-cursors"/>
<package name="dnsmasq"/>
<package name="dosfstools"/>
<package name="droid-fonts"/>
<package name="dvd+rw-tools"/>
<package name="editres"/>
<package name="eject"/>
<package name="ethtool"/>
<package name="fifth-leg-font"/>
<package name="file"/>
<package name="fillup"/>
<package name="findutils"/>
<package name="fonttosfnt"/>
<package name="foomatic-filters"/>
<!--<package name="freeglut"/> -->
<package name="freerdp"/>
<package name="fslsfonts"/>
<package name="fstobdf"/>
<package name="gawk"/>
<package name="gdb"/>
<package name="genisoimage"/>
<package name="geoclue"/>
<!--<package name="gfxboot"/> -->
<package name="ghostscript"/>
<package name="ghostscript-fonts-other"/>
<package name="ghostscript-fonts-std"/>
<package name="ghostscript-x11"/>
<package name="gimp"/>
<package name="gimp-help"/>
<package name="gimp-lang"/>
<package name="glchess"/>
<package name="glib2-tools"/>
<package name="gnuchess"/>
<package name="gpart"/>
<package name="gpm"/>
<package name="grep"/>
<package name="gstreamer" />
<package name="gstreamer-plugins-bad"/>
<package name="gstreamer-plugins-base"/>
<package name="gstreamer-plugins-good"/>
<package name="gstreamer-plugins-ugly"/>
<package name="gutenprint"/>
<package name="gvfs"/>
<package name="gvfs-backends"/>
<package name="gvfs-fuse"/>
<package name="gvfs-lang"/>
<package name="gzip"/>
<package name="hdparm"/>
<package name="hicolor-icon-theme"/>
<package name="hplip"/>
<package name="iceauth"/>
<package name="ico"/>
<package name="ifnteuro"/>
<package name="info"/>
<package name="iptables"/>
<package name="iso-codes"/>
<package name="iso-codes-lang"/>
<package name="java-1_7_0-openjdk"/>
<package name="java-ca-certificates"/>
<package name="keyutils"/>
<package name="kpartx"/>
<package name="lbxproxy"/>
<package name="libatm1"/>
<package name="libbz2-1"/>
<package name="liberation-fonts"/>
<package name="libfam0-gamin"/>
<package name="libgarcon-branding-openSUSE"/>
<package name="libgarcon-data"/>
<package name="libglib-2_0-0"/>
<package name="libnotify-tools"/>
<package name="libnice"/>
<package name="libxml2-2"/>
<package name="libxml2-python"/>
<package name="libXaw7"/>
<package name="libyui-qt-pkg7" /><!-- libyui-gtk-pkg6 is no more maintained and has been dropped from factory. See: bug#901851 -->
<package name="listres"/>
<package name="lockdev"/>
<package name="logrotate"/>
<package name="lsb-release"/>
<package name="lsof"/>
<package name="lsscsi"/>
<package name="luit"/>
<package name="lukemftp"/>
<package name="mailx"/>
<package name="man"/>
<package name="mdadm"/>
<package name="media-player-info"/>
<package name="midori-branding-openSUSE"/>
<package name="mjpegtools"/>
<package name="mkcomposecache"/>
<package name="mkfontdir"/>
<package name="mkfontscale"/>
<package name="mobile-broadband-provider-info"/>
<package name="mozilla-nss"/>
<package name="mozilla-nss-certs"/>
<package name="netcat-openbsd"/>
<package name="nfs-client"/>
<package name="nfsidmap"/>
<package name="nss-mdns"/>
<package name="ntfs-3g"/>
<package name="ntfsprogs"/>
<package name="numlockx"/>
<package name="oclock"/>
<package name="openldap2-client"/>
<package name="openslp"/>
<package name="openssh-askpass"/>
<package name="openssl"/>
<package name="org.freedesktop.ModemManager"/>
<package name="pam"/>
<package name="pam-modules"/>
<package name="parted"/>
<package name="patterns-base-base"/>
<package name="patterns-base-enhanced_base"/>
<package name="patterns-base-enhanced_base_opt"/>
<package name="patterns-base-sw_management"/>
<package name="patterns-base-x11"/>
<package name="patterns-base-x11_opt"/>
<package name="patterns-desktop-imaging"/>
<package name="patterns-desktop-imaging_opt"/>
<package name="patterns-desktop-multimedia"/>
<package name="patterns-desktop-multimedia_opt"/>
<package name="patterns-fonts-fonts"/>
<package name="patterns-fonts-fonts_opt"/>
<package name="patterns-yast-x11_yast"/>
<package name="patterns-yast-yast2_basis"/>
<package name="pciutils"/>
<package name="perl"/>
<package name="perl-Net-DBus"/>
<package name="perl-X11-Protocol"/>
<package name="perl-base"/>
<package name="permissions"/>
<package name="pinentry"/>
<package name="pk-update-icon"/>
<package name="pk-update-icon-lang"/>
<package name="pkgconfig"/>
<package name="postfix"/>
<package name="ppp"/>
<package name="pptp"/>
<package name="proxymngr"/>
<package name="psmisc"/>
<package name="python"/>
<package name="python-base"/>
<package name="python-beautifulsoup"/>
<package name="python-gobject"/>
<package name="python-gobject2"/>
<package name="python-httplib2"/>
<package name="python-qt4"/>
<package name="python-simplejson"/>
<package name="python-urlgrabber"/>
<package name="python-xml"/>
<package name="recode"/>
<package name="release-notes-openSUSE"/>
<package name="rendercheck"/>
<package name="rgb"/>
<package name="rhino"/>
<package name="rpm-python"/>
<package name="rstart"/>
<package name="samba"/>
<package name="scout"/>
<package name="sed"/>
<package name="sessreg"/>
<package name="setxkbmap"/>
<package name="shared-mime-info"/>
<package name="showfont"/>
<package name="smp_utils"/>
<package name="smproxy"/>
<package name="smtp_daemon"/>
<package name="sound-theme-freedesktop"/>
<package name="sox"/>
<package name="strace"/>
<!--<package name="suspend"/> -->
<package name="system-config-printer"/>
<package name="system-config-printer-applet"/>
<package name="tar"/>
<package name="translation-update"/>
<package name="tzdata-java"/>
<package name="nscd"/>
<package name="update-alternatives"/>
<package name="utempter"/>
<package name="viewres"/>
<package name="vim"/>
<package name="vorbis-tools"/>
<package name="w3m"/>
<package name="wallpaper-branding"/>
<package name="wallpaper-branding-openSUSE"/>
<package name="wdiff"/>
<package name="wodim"/>
<package name="xfce4-terminal"/>
<package name="xfd"/>
<package name="xfindproxy"/>
<package name="xfontsel"/>
<package name="xfs"/>
<package name="xfsinfo"/>
<package name="xfwp"/>
<package name="xgamma"/>
<package name="xgc"/>
<package name="xhost"/>
<package name="xinetd"/>
<package name="xinit"/>
<package name="xinput"/>
<package name="xkbcomp"/>
<package name="xkbevd"/>
<package name="xkbprint"/>
<package name="xkbutils"/>
<package name="xkeyboard-config"/>
<package name="xkill"/>
<package name="xload"/>
<package name="xlogo"/>
<package name="xlsatoms"/>
<package name="xlsclients"/>
<package name="xlsfonts"/>
<package name="xmag"/>
<package name="xman"/>
<package name="xmessage"/>
<package name="xmlbeans"/>
<package name="xmodmap"/>
<package name="xmore"/>
<package name="xorg-scripts"/>
<package name="xorg-x11"/>
<package name="xorg-x11-driver-input"/>
<package name="xorg-x11-fonts-core"/>
<package name="xorg-x11-libX11-ccache"/>
<package name="xorg-x11-server"/>
<package name="xorg-x11-server-extra"/>
<package name="xorg-x11-xauth"/>
<package name="xplsprinters"/>
<package name="xpr"/>
<package name="xprehashprinterlist"/>
<package name="xprop"/>
<package name="xrandr"/>
<package name="xrdb"/>
<package name="xrefresh"/>
<package name="xrestop"/>
<package name="xrx"/>
<package name="xscope"/>
<package name="xscreensaver"/>
<package name="xscreensaver-data"/>
<package name="xset"/>
<package name="xsetmode"/>
<package name="xsetpointer"/>
<package name="xsetroot"/>
<package name="xsm"/>
<package name="xstdcmap"/>
<package name="xterm"/>
<package name="xtermset"/>
<package name="xtrap"/>
<package name="xvidtune"/>
<package name="xvinfo"/>
<package name="xwd"/>
<package name="xwininfo"/>
<package name="xwud"/>
<package name="xz"/>
<package name="xz-lang"/>
<package name="x11-tools"/>
<package name="x11perf"/>
<package name="xauth"/>
<package name="xbacklight"/>
<package name="xbiff"/>
<package name="xcalc"/>
<package name="xclipboard"/>
<package name="xclock"/>
<package name="xcmsdb"/>
<package name="xcompmgr"/>
<package name="xconsole"/>
<package name="xcursor-themes"/>
<package name="xcursorgen"/>
<package name="xdbedizzy"/>
<package name="xdg-user-dirs"/>
<package name="xdg-user-dirs-gtk"/>
<package name="xdg-user-dirs-gtk-lang"/>
<package name="xdg-utils"/>
<package name="xditview"/>
<package name="xdm"/>
<package name="xdmbgrd"/>
<package name="xdpyinfo"/>
<package name="xedit"/>
<package name="xev"/>
<package name="xeyes"/>
<package name="xf86-input-evdev"/>
<package name="xf86-input-joystick"/>
<package name="xf86-input-keyboard"/>
<package name="xf86-input-mouse"/>
<package name="xf86-input-synaptics"/>
<!--<package name="xf86-input-vmmouse"/> -->
<package name="xf86-input-void"/>
<package name="xf86-input-wacom"/>
#if IS_FLAVOR_chromebook
<package name="xf86-video-armsoc"/>
<package name="libevdev0"/>
<package name="chromebook-ucm-profiles"/>
#endif
<package name="xf86-video-ast"/>
<package name="xf86-video-ati"/>
<package name="xf86-video-chips"/>
<package name="xf86-video-cirrus"/>
<package name="xf86-video-dummy"/>
<package name="xf86-video-glint"/>
<package name="xf86-video-i128"/>
<package name="xf86-video-fbdev"/>
<package name="xf86-video-mach64"/>
<package name="xf86-video-nv"/>
#if IS_FLAVOR_panda || IS_FLAVOR_beagle
<package name="xf86-video-omap"/>
#endif
#if !IS_ARCH_aarch64
<package name="xf86-video-qxl"/>
#endif
<package name="xf86-video-r128"/>
#if !IS_ARCH_aarch64
<package name="xf86-video-siliconmotion"/>
#endif
<package name="xf86-video-tdfx"/>
<package name="xf86-video-tga"/>
<package name="xf86-video-vesa"/>
<!--<package name="xf86-video-vmware"/> -->
<package name="xf86-video-voodoo"/>
<package name="xf86dga"/>
<package name="yast2"/>
<package name="yast2-qt-branding-openSUSE"/>
<package name="yast2-control-center"/>
<package name="yast2-scanner"/>
<package name="yast2-sound"/>
<package name="yp-tools"/>
<package name="ypbind"/>
<package name="zip"/>
<package name="zisofs-tools"/>
<!-- E20/LXQT/XFCE: multiple choices -->
<package name="MozillaFirefox-branding-openSUSE"/>
<package name="NetworkManager-branding-openSUSE"/>
<package name="input-utils"/><!-- Choice between input-utils (old) or linuxconsoletools (new) -->
<package name="libgfortran4"/>
<package name="libwbclient0"/><!-- Choice between libwbclient0 from samba pkg (old) or sssd-wbclient (new) -->
<package name="libharfbuzz0"/> <!-- choice between libharfbuzz0 and libharfbuzz0-bootstrap -->
<package name="typelib-1_0-WebKit-3_0"/>
#endif

#if (IMAGE_TYPE == TYPE_XFCE)
<!-- XFCE / xorg specific packages -->
<package name="patterns-xfce-xfce"/>
<!--<package name="openSUSE-release-usb-x11"/>--><!-- No more exist in Factory? -->
<package name="xfce4-panel-branding-openSUSE"/>
<package name="xfce4-session-branding-openSUSE"/>
<!-- manual resolution of recommended packages (OBS does not do it automatically) -->
<!--<package name="AdobeICCProfiles"/> -->
<package name="NetworkManager"/>
<package name="NetworkManager-applet"/>
<package name="NetworkManager-applet-lang"/>
<package name="NetworkManager-client"/>
<package name="NetworkManager-lang"/>
<package name="alacarte"/>
<package name="alacarte-lang"/>
<package name="brasero"/>
<package name="brasero-lang"/>
<package name="canberra-gtk-play"/>
<package name="cheese"/>
<package name="cheese-lang"/>
<package name="chess_backend"/>
<package name="empathy"/>
<package name="empathy-lang"/>
<package name="evince"/>
<package name="evince-lang"/>
<package name="exo-branding-openSUSE"/>
<package name="exo-tools"/>
<package name="file-roller"/>
<package name="file-roller-lang"/>
<package name="five-or-more"/>
<package name="four-in-a-row"/>
<package name="gconf2-branding-openSUSE"/>
<package name="gdmflexiserver"/>
<package name="gnome-chess"/>
<package name="gnome-contacts"/>
<package name="gnome-contacts-lang"/>
<package name="gnome-icon-theme"/>
<package name="gnome-keyring"/>
<package name="gnome-keyring-lang"/>
<package name="gnome-keyring-pam"/>
<package name="gnome-klotski"/>
<package name="gnome-mahjongg"/>
<package name="gnome-mines"/>
<package name="gnome-nibbles"/>
<package name="gnome-packagekit"/>
<package name="gnome-packagekit-lang"/>
<package name="gnome-robots"/>
<package name="gnome-sudoku"/>
<package name="gnome-sudoku-lang"/>
<package name="gnome-tetravex"/>
<package name="gnome-themes-accessibility"/>
<package name="gnome-video-effects"/>
<package name="gsettings-backend-dconf"/>
<package name="gsettings-desktop-schemas"/>
<package name="gsettings-desktop-schemas-lang"/>
<package name="gtk2-engine-clearlooks"/>
<package name="gtk2-engine-hcengine"/>
<package name="gtk2-metatheme-adwaita"/>
<package name="gtk3"/>
<package name="gtk3-metatheme-adwaita"/>
<package name="gtk3-tools"/>
<package name="gucharmap"/>
<package name="gucharmap-lang"/>
<package name="iagno"/>
<package name="iagno-lang"/>
<package name="leafpad"/>
<package name="libcanberra0"/>
<package name="libgnomesu"/>
<package name="libgnomesu0"/>
<!--<package name="libreoffice-gnome"/> -->
<package name="libxfce4ui-branding-openSUSE"/>
<package name="libxfce4ui-tools"/>
<package name="lightdm"/>
<package name="lightdm-greeter"/>
<package name="lightdm-gtk-greeter"/>
<package name="lightdm-gtk-greeter-branding-openSUSE"/>
<package name="lightdm-lang"/>
<package name="lightsoff"/>
<package name="lightsoff-lang"/>
<package name="mahjongg"/>
<package name="nautilus"/>
<package name="nautilus-sendto"/>
<package name="nautilus-sendto-lang"/>
<package name="openSUSE-xfce-icon-theme"/>
<package name="orage"/>
<package name="patterns-xfce-xfce_basis"/>
<package name="patterns-xfce-xfce_office"/>
<package name="pinentry-gtk2"/>
<package name="quadrapassel"/>
<package name="quadrapassel-lang"/>
<package name="rhythmbox"/>
<package name="rhythmbox-lang"/>
<package name="ristretto"/>
<package name="seahorse"/>
<package name="seahorse-lang"/>
<package name="shotwell"/>
<package name="shotwell-lang"/>
<package name="simple-scan"/>
<package name="simple-scan-lang"/>
<package name="sound-juicer"/>
<package name="sound-juicer-lang"/>
<package name="swell-foop"/>
<package name="swell-foop-lang"/>
<package name="tali"/>
<package name="telepathy-gabble"/>
<package name="telepathy-haze"/>
<package name="telepathy-idle"/>
<package name="telepathy-logger"/>
<package name="telepathy-mission-control"/>
<package name="telepathy-salut"/>
<package name="thunar"/>
<package name="thunar-plugin-archive"/>
<package name="thunar-plugin-media-tags"/>
<package name="thunar-volman"/>
<package name="thunar-volman-branding-openSUSE"/>
<package name="totem"/>
<package name="totem-lang"/>
<package name="totem-plugins"/>
<!--<package name="tracker"/>
<package name="tracker-gui"/>
<package name="tracker-lang"/>
<package name="tracker-miner-files"/> -->
<package name="transmission-gtk"/>
<package name="transmission-gtk-lang"/>
<package name="tumbler"/>
<package name="xfce4-appfinder"/>
<package name="xfce4-dict"/>
<package name="xfce4-mixer"/>
<package name="xfce4-notifyd"/>
<package name="xfce4-notifyd-branding-openSUSE"/>
<package name="xfce4-panel"/>
<package name="xfce4-panel-plugin-mixer"/>
<package name="xfce4-panel-plugin-notes"/>
<package name="xfce4-panel-plugin-xkb"/>
<package name="xfce4-power-manager"/>
<package name="xfce4-screenshooter"/>
<package name="xfce4-session"/>
<package name="xfce4-settings"/>
<package name="xfce4-settings-branding-openSUSE"/>
<package name="xfce4-taskmanager"/>
<package name="xfconf"/>
<package name="xfdesktop"/>
<package name="xfdesktop-branding-openSUSE"/>
<package name="xfwm4"/>
<package name="xfwm4-branding-openSUSE"/>
<package name="yast2-control-center-gnome"/>
<package name="yast2-control-center-qt"/>
<package name="yast2-qt"/>
<package name="yast2-qt-pkg"/>
<package name="yelp"/>
<package name="yelp-lang"/>
<package name="yelp-xsl"/>

<!-- XFCE: multiple choices -->
<!-- Means packages with multiple resolvables. E.g.: bootsplash could also be provided by plymouth. -->
<package name="gnome-menus-branding-openSUSE"/>

<!-- XFCE: Additional packages -->
<package name="gnome-bluetooth"/>
#endif

#if (IMAGE_TYPE == TYPE_E20)
<!-- E20 specific packages -->
<!-- TODO: Try to get rid of all GNOME related things -->
<package name="enlightenment"/>
<package name="efreet"/>
<package name="terminology"/>
<!-- Use lightdm as Display Manager -->
<package name="lightdm"/>
<package name="lightdm-greeter"/>
<package name="lightdm-gtk-greeter"/>
<package name="lightdm-gtk-greeter-branding-openSUSE"/>
<package name="lightdm-lang"/>
<!-- TODO: Replace networkmanager by econnman once connman is avalaible -->
<!-- <package name="connman" /> -->
<!-- <package name="econnman" /> -->
<package name="NetworkManager"/>
<package name="NetworkManager-applet"/>
<package name="NetworkManager-applet-lang"/>
<package name="NetworkManager-client"/>
<package name="NetworkManager-lang"/>
<!-- E20: multiple choices -->
<package name="enlightenment-branding-openSUSE"/>
<package name="enlightenment-theme-openSUSE"/>
<package name="oxygen5-icon-theme"/>
<package name="python"/>
<!-- Have choice between *-gnome and *-qt -->
<package name="gnome-menus-branding-openSUSE"/>
<package name="libexo-1-0-branding-openSUSE" />
<package name="yast2-control-center-gnome"/>
#endif

#if (IMAGE_TYPE == TYPE_LXQT)
<!-- LXQT specific packages -->
<!-- Requires from pattern LXQT -->
<package name="compton" />
<package name="compton-conf" />
<package name="lximage-qt" />
<package name="lxmenu-data" />
<package name="lxqt-about" />
<package name="lxqt-common" />
<package name="lxqt-config" />
<package name="lxqt-globalkeys-qt5" />
<package name="lxqt-notificationd" />
<package name="lxqt-openssh-askpass" />
<package name="lxqt-panel" />
<package name="lxqt-policykit" />
<package name="lxqt-powermanagement" />
<package name="lxqt-qtplugin" />
<package name="lxqt-runner" />
<package name="lxqt-session" />
<package name="menu-cache" />
<package name="openbox" />
<package name="obconf" /><!-- <package name="obconf-qt" /> -->
<package name="pcmanfm-qt" />
<package name="NetworkManager" />
<package name="NetworkManager-applet" />
<!-- Recommends from pattern LXQT -->
<!-- <package name="lxqt-lightdm-greeter" /> -->
<package name="lightdm" />
<!-- <package name="lxqt-appswitcher" /> -->
<!-- Have choices -->
<package name="gnome-menus-branding-openSUSE"/>
<package name="libexo-1-0-branding-openSUSE" />
<package name="yast2-control-center-qt"/>
<!-- <package name="lightdm-kde-greeter"/> Prefer GTK since kde-greeter does not work -->
<package name="lightdm-gtk-greeter"/>
<package name="lightdm-gtk-greeter-branding-openSUSE"/>
<package name="kdebase4-openSUSE" />
<package name="kdelibs4-branding-openSUSE" />
<package name="oxygen5-cursors" />
#endif
#if (IMAGE_TYPE == TYPE_X11)
<!-- X11/IceWM-specific packages -->
<package name="icewm"/>
<package name="icewm-lite"/>
<package name="icewm-default"/>
<package name="icewm-theme-branding"/>
<package name="icewm-lang"/>
#endif
