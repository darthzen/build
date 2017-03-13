<!-- Patterns -->
<namedCollection name="Minimal" />
<namedCollection name="base" />
<namedCollection name="documentation" />
<namedCollection name="x11" />
<namedCollection name="Basis-Devel" />
<namedCollection name="SDK-C-C++" />
<namedCollection name="SDK-YaST" />
<namedCollection name="SDK-Doc" />
<!-- AppArmor slows startup down by a long time
<namedCollection name="apparmor" /> -->
<namedCollection name="dhcp_dns_server" />
<namedCollection name="directory_server" />
<namedCollection name="file_server" />
<namedCollection name="gateway_server" />
<!-- Cant use this as tftp conflicts with atftp needed by kiwi-desc-oemboot-requires.
<namedCollection name="kvm_server" />
<namedCollection name="kvm_tools" />-->
<namedCollection name="lamp_server" />
<namedCollection name="mail_server" />
<namedCollection name="printing" />
<namedCollection name="WBEM" />
<!--<namedCollection name="gcc6" />-->

<package name="patterns-sles-Minimal" />
<package name="patterns-sles-base" />
<package name="patterns-sles-documentation" />
<package name="patterns-sles-x11" />
<package name="patterns-sles-Basis-Devel" />
<package name="patterns-sdk-SDK-C-C++" />
<package name="patterns-sdk-SDK-YaST" />
<package name="patterns-sdk-SDK-Doc" />
<!--<package name="patterns-sles-apparmor" />-->
<package name="patterns-sles-dhcp_dns_server" />
<package name="patterns-sles-directory_server" />
<package name="patterns-sles-file_server" />
<package name="patterns-sles-gateway_server" />
<!--<package name="patterns-sles-kvm_server" />
<package name="patterns-sles-kvm_tools" />-->
<package name="patterns-sles-lamp_server" />
<package name="patterns-sles-mail_server" />
<package name="patterns-sles-printing" />
<package name="patterns-sles-WBEM" />
<!--<package name="patterns-toolchain-gcc6"/>-->

<package name="suse-build-key"/>

<!-- Base packages -->
<package name="aaa_base-extras"/>
<package name="acl"/>
<package name="alsa"/>
<package name="audit"/>
<package name="bluez"/>
<package name="branding-SLE"/>
<package name="gio-branding-SLE"/>
<package name="ca-certificates"/>
<package name="ca-certificates-mozilla"/>
<package name="cracklib-dict-full"/>
<package name="dracut"/>
<package name="e2fsprogs"/>
<package name="elfutils"/>
<package name="filesystem"/>
<package name="fipscheck" />
<package name="gettext-runtime"/><!-- Do not use gettext-runtime-mini-->
<package name="glibc-locale"/>
<package name="gpg2"/>
<package name="grub2" bootinclude="true"/>
<package name="grub2-arm64-efi" bootinclude="true"/>
<package name="insserv-compat"/>
<package name="iproute2"/>
<package name="iputils"/>
<package name="iw"/>
<package name="kernel-firmware"/>
<package name="krb5"/><!-- Do not use krb5-mini -->
<package name="less"/>
<package name="libudev1"/><!-- Do not use libudev-mini1 -->
<package name="libyui-ncurses-pkg7"/>
<package name="lvm2"/>
<package name="kmod-compat"/>
<package name="ncurses-utils"/>
<package name="net-tools"/>
<!-- extra stuff needed for cloud -->
<package name="haveged"/>
<package name="nfs-client"/>
<package name="rpcbind"/>
<!-- we need to keep our time in sync, because there is no RTC -->
<package name="ntp"/>
<package name="openssh"/>
<package name="pkg-config"/>
<package name="python-base"/>
<package name="sudo"/>
<package name="sysconfig"/>
<package name="sysconfig-netconfig"/>
<package name="udev"/>
<package name="rsyslog"/>
<package name="shadow"/>
<package name="sg3_utils"/>
<package name="SuSEfirewall2"/>
<package name="systemd"/> <!-- avoid using systemd-mini -->
<package name="systemd-sysvinit"/>
<package name="timezone"/>
<package name="util-linux-systemd"/>
<package name="usbutils"/>
<package name="which"/>
<package name="wicked"/>
<package name="wicked-service"/>
<package name="vim"/>
<package name="wget"/>
<package name="wireless-tools"/>
<package name="wpa_supplicant"/>
<package name="yast2-firewall"/>
<package name="yast2-firstboot"/>

<!-- additional packages needed by firstboot -->
<package name="SLES_RPI-release-MINI"/>
<package name="SLES_RPI-release"/>
<package name="yast2-users"/>
<package name="zypper"/>

<!-- Base: multiple choices -->
<package name="libffi4"/>
<package name="libgcc_s1"/>
<package name="libgomp1"/>
<package name="libitm1"/>
<package name="libubsan0"/>
<package name="libatomic1"/>
<package name="libsystemd0"/> <!-- avoid using libsystemd0-mini -->
<package name="unzip"/>
<package name="ruby2.1-rubygem-ruby-dbus" /> <!-- needed by yast2-storage -->
<package name="ruby2.1-rubygem-gem2rpm" /> <!-- needed by ruby-common -->
<package name="ruby2.1-rubygem-cfa" /> <!-- needed by yast2 -->
<package name="ruby2.1-rubygem-cheetah" /> <!-- needed by yast2 -->
<package name="emacs-x11" /> <!-- emacs_program -->
<package name="typelib-1_0-Vte-2.91" /> <!-- typelib(Vte) -->

<!-- Drivers -->
<package name="xf86-input-evdev"/>
<package name="xf86-input-synaptics"/>
<package name="xf86-input-void"/>
<package name="xf86-video-fbdev"/>

<!-- Other X11 packages -->
<package name="gconf2"/>
<package name="xfd"/>
<package name="xfontsel"/>
<package name="xfs"/>
<package name="xgamma"/>
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
<package name="xlogo"/>
<package name="xlsatoms"/>
<package name="xlsclients"/>
<package name="xlsfonts"/>
<package name="xmag"/>
<package name="xmessage"/>
<package name="xmlbeans"/>
<package name="xmodmap"/>
<package name="xorg-x11"/>
<package name="xorg-x11-driver-input"/>
<package name="xorg-x11-fonts-core"/>
<package name="xorg-x11-libX11-ccache"/>
<package name="xorg-x11-server"/>
<package name="xorg-x11-server-extra"/>
<package name="xprop"/>
<package name="xrandr"/>
<package name="xrdb"/>
<package name="xrefresh"/>
<package name="xrestop"/>
<package name="xscope"/>
<package name="xscreensaver"/>
<package name="xscreensaver-data"/>
<package name="xset"/>
<package name="xsetmode"/>
<package name="xsetpointer"/>
<package name="xsetroot"/>
<package name="xterm"/>
<package name="xtermset"/>
<package name="xvinfo"/>
<package name="xwd"/>
<package name="xwininfo"/>
<package name="xdm"/>
<package name="x11-tools"/>
<package name="x11perf"/>
<package name="xauth"/>
<package name="xbacklight"/>
<package name="xbiff"/>
<package name="xclock"/>
<package name="xconsole"/>
<package name="xcursor-themes"/>
<package name="xcursorgen"/>
<package name="xdg-user-dirs"/>
<package name="xdg-user-dirs-gtk"/>
<package name="xdg-user-dirs-gtk-lang"/>
<package name="xdg-utils"/>
<package name="xdmbgrd"/>
<package name="xdpyinfo"/>
<package name="xev"/>
<package name="xeyes"/>
<package name="yast2-x11"/>
<package name="gtk3-metatheme-adwaita"/>
<package name="gtk2-metatheme-adwaita"/>

<!-- Branding -->
<package name="grub2-branding-SLE" bootinclude="true"/>
<package name="yast2-branding-SLE"/>
<package name="MozillaFirefox-branding-SLE"/>
<package name="release-notes-sles"/>

<!-- Translations -->
<package name="glib-networking-lang"/>
<package name="dirmngr-lang"/>
<package name="shared-mime-info-lang"/>
<package name="gstreamer-lang"/>
<package name="tcsh-lang"/>
<package name="gconf2-lang"/>
<package name="tar-lang"/>
<package name="cpio-lang"/>
<package name="sharutils-lang"/>
<package name="xz-lang"/>
<package name="parted-lang"/>
<package name="gpg2-lang"/>
<package name="sed-lang"/>
<package name="findutils-lang"/>
<package name="icewm-lang"/>
<package name="xkeyboard-config-lang"/>
<package name="gsettings-desktop-schemas-lang"/>
<package name="psmisc-lang"/>
<package name="bash-lang"/>
<package name="coreutils-lang"/>
<package name="util-linux-lang"/>
<package name="at-spi2-core-lang"/>
<package name="vorbis-tools-lang"/>
<package name="yast2-trans-allpacks"/>
<package name="desktop-translations"/>

<!-- X11/IceWM-specific packages -->
<package name="icewm"/>
<package name="icewm-lite"/>
<package name="icewm-default"/>
<package name="icewm-theme-branding"/>

<package name="polkit-gnome-lang"/>
<package name="polkit-default-privs"/>

<!-- Needed for aarch64 qemu with efi -->
<package name="qemu-ipxe"/>

<!-- Useful for kinda-embedded systems -->
<package name="cpupower"/>

<!-- SDK -->
<package name="sle-sdk-release-POOL"/>
<package name="tack"/>
<package name="release-notes-sdk"/>
<package name="man"/>
<package name="man-pages"/>

<!-- Toolchain -->
<package name="sle-module-toolchain-release-POOL"/>

<!-- Pattern not available in SUSE:SLE-12-SP2:GA -->
<package name="gcc6"/>
<package name="gcc6-c++"/>
<package name="cpp6"/>
<package name="gcc6-fortran"/>
<package name="gcc6-locale"/>
<!--<package name="libffi-devel-gcc5"/>-->
<package name="libstdc++6-devel-gcc6"/>

<!-- Cant use pattern kvm_server, see above -->
<package name="bridge-utils" />
<package name="qemu-arm" />
<package name="qemu-uefi-aarch64" />
<package name="tigervnc" />
<package name="libvirt-daemon-qemu" />
<package name="vm-install" />
<package name="virt-install" />

<!-- kvm_tools requires kvm_server... -->
<package name="tigervnc" />
<package name="virt-manager" />
<package name="libvirt-daemon-qemu" />
<package name="vm-install" />
<package name="libvirt-daemon-config-network" />
<package name="yast2-vm" />
<package name="sles-kvm_en-pdf" />
<package name="virt-v2v" />
