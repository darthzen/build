#
# spec file for package kiwi-templates-SLES12-RPi
#
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


%define dest %{_datadir}/kiwi/image/suse-SLE12-Enterprise-RPi
Name:           kiwi-templates-SLES12-RPi
Version:        12
Release:        0
Summary:        KIWI - SUSE Linux Enterprise 12 RPi image templates
License:        MIT
Group:          System/Management
Url:            https://www.suse.com/
Source1:        pre_checkin.sh
Source2:        Images.kiwi.in
Source3:        packagelist.rpi3.inc
Source4:        uboot-image-install.in
Source5:        uboot-image-setup.in
Source6:        installUBoot.sh
Source7:        config.sh
Source8:        y2firstboot.tar.gz
Source99:       LICENSE
# Generated files:
Source100:      uboot-image-raspberrypi3_aarch64-install
Source101:      uboot-image-raspberrypi3_aarch64-setup
Source102:      uboot-setup-raspberrypi3_aarch64.tgz
Source103:      X11-raspberrypi3_aarch64.kiwi
BuildRequires:  kiwi
Requires:       kiwi
Supplements:    packageand(kiwi:kiwi-templates)
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
This package contains system image templates to easily build
a SUSE Linux Enterprise 12 RPi based operating system image with
kiwi.

%prep
%setup -q -cT
cp -- "%{SOURCE99}" .

%build

%install
mkdir -p %{buildroot}%{dest}
for i in %{SOURCE1} %{SOURCE2} %{SOURCE3} %{SOURCE4} %{SOURCE5} \
         %{SOURCE6} %{SOURCE7} %{SOURCE8} \
         %{SOURCE100} %{SOURCE101} %{SOURCE102} %{SOURCE103}; do
	install -m 644 $i %{buildroot}%{dest}
done

%files
%defattr(-,root,root)
%doc LICENSE
%{dest}

%changelog
