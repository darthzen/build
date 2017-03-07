FROM suse/sles12sp2:latest

MAINTAINER Rick Ashford <rick.ashford@suse.com>

ENV container docker

RUN zypper --non-interactive remove container-suseconnect; \
    zypper addrepo -t yast2 http://172.17.0.1/install/SLES12-SP2-x86_64 SLES12-SP2-x86_64; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update SLES12-SP2-x86_64-Updates; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Products/SLE-SDK/12-SP2/x86_64/product SLE-SDK; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-SDK/12-SP2/x86_64/update SLE-SDK-Updates; \ 
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Products/SLE-Module-Web-Scripting/12/x86_64/product SLE-Module-Web-Scripting; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-Module-Web-Scripting/12/x86_64/update SLE-Module-Web-Scripting-Updates; \
    zypper --non-interactive --gpg-auto-import-keys update --auto-agree-with-licenses; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses -t pattern lamp_server

ADD apache2 /etc/sysconfig/apache2

VOLUME /etc/apache2/vhosts.d/
VOLUME /etc/ssl

EXPOSE 80
EXPOSE 443

#CMD [ "/sbin/init" ]
CMD /usr/lib/systemd/systemd --system --unit=apache2.service
