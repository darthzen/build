FROM opensuse:leap

MAINTAINER Rick Ashford <rick.ashford@suse.com>

RUN zypper --gpg-auto-import-keys refresh --force; \
    zypper --non-interactive --gpg-auto-import-keys update --auto-agree-with-licenses; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses httrack;

RUN mkdir /mirror

VOLUME ["/mirror"]
WORKDIR /mirror

CMD /bin/bash
