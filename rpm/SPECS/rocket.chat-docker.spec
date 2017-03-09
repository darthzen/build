#
# spec file for package rocket.chat-docker-image-0.53.0-1
#
# Copyright (c) 2017 SUSE LINUX Products GmbH, Nuernberg, Germany.
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

Name:           rocket.chat-docker
Version: 0.53.0
Release: 1
License:
Summary:
Url:
Group: Applications/Communications
Source: rocket.chat.tar.gz
Patch:
BuildRequires: docker
PreReq:
Provides:
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description

%prep
%setup -q

%build
docker build -t suse/rocket.chat:%{version} --force-rm .
docker save suse/rocket.chat:%{version} > rocket.chat-%{version}.tar.gz

%install
docker import rocket.chat-%{version}.tar.gz suse/rocket.chat:%{version}

%post

%postun

%files
%defattr(-,root,root)
%doc ChangeLog README COPYING


