#
# spec file for package coffee-script
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
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

Name:          coffee-script
Summary:       Little language that compiles into JavaScript
License:       MIT
URL:           https://github.com/jashkenas/coffeescript
Group:         Development/Languages/NodeJS
Version:       1.4.0
Release:       0
Source:	http://registry.npmjs.org/%{name}/-/%{name}-%{version}.tgz
Source1:	macros.coffeescript
BuildRoot:     %{_tmppath}/%{name}-%{version}-root
BuildRequires:	nodejs-packaging
BuildArch:     noarch 
%nodejs_find_provides_and_requires

%description
CoffeeScript is a little language that compiles into JavaScript. Underneath all
of those embarrassing braces and semicolons, JavaScript has always had a
gorgeous object model at its heart. CoffeeScript is an attempt to expose the
good parts of JavaScript in a simple way.

The golden rule of CoffeeScript is: "It's just JavaScript". The code compiles
one-to-one into the equivalent JS, and there is no interpretation at runtime.
You can use any existing JavaScript library seamlessly (and vice-versa).
The compiled output is readable and pretty-printed, passes through JavaScript
Lint without warnings, will work in every JavaScript implementation, and tends
to run as fast or faster than the equivalent handwritten JavaScript.

%prep
%setup -q -n package

%build

%install
mkdir -p %{buildroot}%{nodejs_sitelib}/%{name}
mv package.json bin lib \
	%{buildroot}%{nodejs_sitelib}/%{name} 
%nodejs_clean
mkdir -p %{buildroot}%{_prefix}/bin
ln -sf %{nodejs_sitelib}/%{name}/bin/cake %{buildroot}%{_prefix}/bin/cake
ln -sf %{nodejs_sitelib}/%{name}/bin/coffee %{buildroot}%{_prefix}/bin/coffee

# Install RPM macros
install -d %{buildroot}%{_sysconfdir}/rpm
install -m 644 %{SOURCE1} %{buildroot}%{_sysconfdir}/rpm

%files
%defattr(-, root, root)
%doc README.md LICENSE CONTRIBUTING.md
%config %{_sysconfdir}/rpm/macros.coffeescript
%{_bindir}/coffee
%{_bindir}/cake
%{nodejs_sitelib}/%{name}

%changelog
