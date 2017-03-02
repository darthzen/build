FROM suse/sles12sp2

MAINTAINER Rick Ashford <rick.ashford@suse.com>

RUN zypper --non-interactive remove container-suseconnect; \
    zypper addrepo -t yast2 http://192.168.124.1/install/SLES12-SP2-x86_64 SLES12-SP2-x86_64; \
    zypper addrepo -t rpm-md http://192.168.124.1/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update SLES12-SP2-x86_64-Updates; \
    zypper addrepo -t rpm-md http://192.168.124.1/repo/SUSE/Products/SLE-Module-Web-Scripting/12/x86_64/product SLE-Module-Web-Scripting; \
    zypper addrepo -t rpm-md http://192.168.124.1/repo/SUSE/Updates/SLE-Module-Web-Scripting/12/x86_64/update SLE-Module-Web-Scripting-Updates; \
    zypper addrepo -t rpm-md http://download.opensuse.org/repositories/server:/database/SLE_12_SP2 server:database; \
    zypper --non-interactive --gpg-auto-import-keys update --auto-agree-with-licenses; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses systemd-sysvinit; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses --recommends mongodb; \
    systemctl enable mongodb

ADD mongodb.conf /etc/mongodb.conf
# Define mountable directories.
VOLUME ["/var/lib/mongodb/"]

EXPOSE 27017

ENTRYPOINT ["/usr/lib/systemd/systemd", "--system"]
CMD [ "--unit=mongodb.service"]

