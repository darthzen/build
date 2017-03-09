#
# spec file for package nodejs-promise
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


%define base_name promise
Name:           nodejs-promise
Version:        6.0.0
Release:        0
Summary:        Bare bones Promises/A+ implementation
License:        MIT
Group:          Development/Languages/Other
Url:            https://github.com/then/promise
Source:         http://registry.npmjs.org/%{base_name}/-/%{base_name}-%{version}.tgz
BuildRequires:   nodejs-packaging
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch

%nodejs_find_provides_and_requires

%description
This is a simple implementation of Promises.

It is a super set of ES6 Promises designed to have readable,
performant code and to provide just the extensions that are
absolutely necessary for using promises today.

%prep
%setup -q -n package

%build

%install
mkdir -p %{buildroot}%{nodejs_modulesdir}/%{base_name}
cp -pr package.json *.js lib \
        %{buildroot}%{nodejs_modulesdir}/%{base_name}/

%files
%defattr(-,root,root,-)
%doc Readme.md LICENSE
%{nodejs_modulesdir}/%{base_name}

%changelog
