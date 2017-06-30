FROM suse/sles12sp2:latest

MAINTAINER Rick Ashford <rick.ashford@suse.com>

RUN zypper --non-interactive remove container-suseconnect; \
    zypper addrepo -t yast2 http://ark.ash4d.com/install/SLES12-SP2-x86_64/CD1 SLES12-SP2-x86_64; \
    zypper addrepo -t rpm-md http://ark.ash4d.com/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update SLES12-SP2-x86_64-Updates; \
    zypper addrepo -t rpm-md http://ark.ash4d.com/repo/SUSE/Products/SLE-SDK/12-SP2/x86_64/product SLE-SDK; \
    zypper addrepo -t rpm-md http://ark.ash4d.com/repo/SUSE/Updates/SLE-SDK/12-SP2/x86_64/update SLE-SDK-Updates; \ 
    zypper addrepo -t rpm-md http://ark.ash4d.com/repo/SUSE/Products/SLE-Module-Web-Scripting/12/x86_64/product SLE-Module-Web-Scripting; \
    zypper addrepo -t rpm-md http://ark.ash4d.com/repo/SUSE/Updates/SLE-Module-Web-Scripting/12/x86_64/update SLE-Module-Web-Scripting-Updates; \
    zypper addrepo -t rpm-md http://download.opensuse.org/repositories/network:/jangouts/SLE_12_SP2/network:jangouts.repo; 

RUN zypper --gpg-auto-import-keys refresh --force; \
    zypper --non-interactive --gpg-auto-import-keys update --auto-agree-with-licenses; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses apache2 jangouts;

RUN sed -i 's/127.0.0.1/janus.ash4d.com/g' /etc/apache2/vhosts.d/jangouts-common.inc

EXPOSE 80
EXPOSE 443

CMD /usr/sbin/start_apache2 -DSYSTEMD -DFOREGROUND -k start
