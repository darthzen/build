#
# spec file for package nodejs-meteor
#
# Copyright (c) 2014 SUSE LINUX Products GmbH, Nuernberg, Germany.
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


%define base_name meteor
%define TARGET usr/share/${name}
Name:           nodejs-meteor
Version:        0.5.2
Release:        1
Summary:        Javascript-based web application framework
License:        MIT
Group:          Development/Languages/Other
Url:            https://github.com/meteor/meteor
Source:         http://registry.npmjs.org/%{base_name}/-/%{base_name}-%{version}.tgz
BuildRequires:   nodejs-packaging
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      x86_64

%nodejs_find_provides_and_requires

%description
Meteor is an ultra-simple environment for building modern web applications.

With Meteor you write apps:

* in pure Javascript
* that send data over the wire, rather than HTML
* using your choice of popular open-source libraries

%prep
%setup -q -n package

%install
mkdir -p $RPM_BUILD_ROOT/usr/bin
mkdir -p $RPM_BUILD_ROOT/%{TARGET}
mkdir -p $RPM_BUILD_ROOT/%{nodejs_modulesdir}/%{base_name}
cp package.json $RPM_BUILD_ROOT/%{nodejs_modulesdir}/%{base_name}
cp -a dev_bundle $RPM_BUILD_ROOT/%{TARGET}
cp -r LICENSE.txt History.md meteor app $RPM_BUILD_ROOT/%{TARGET}
cd $RPM_BUILD_ROOT/usr/bin
ln -sf ../share/${name}/meteor

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc docs/client docs/public
%{nodejs_modulesdir}/%{base_name}
/usr
