FROM suse/sles12sp2:latest

MAINTAINER Rick Ashford <rick.ashford@suse.com>

RUN zypper --non-interactive remove container-suseconnect; \
    zypper addrepo -t yast2 http://172.17.0.1/install/SLES12-SP2-x86_64/CD1 SLES12-SP2-x86_64; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update SLES12-SP2-x86_64-Updates; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Products/SLE-SDK/12-SP2/x86_64/product SLE-SDK; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-SDK/12-SP2/x86_64/update SLE-SDK-Updates; \ 
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Products/SLE-Module-Web-Scripting/12/x86_64/product SLE-Module-Web-Scripting; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-Module-Web-Scripting/12/x86_64/update SLE-Module-Web-Scripting-Updates; \
    zypper addrepo -t rpm-md http://download.opensuse.org/repositories/devel:/tools:/building/SLE_12_SP2/devel:tools:building.repo; \
    zypper --non-interactive --gpg-auto-import-keys update --auto-agree-with-licenses; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses jenkins dejavu-fonts git; \
    sed -i 's/-Xmx640m/-Xmx1024m/g' /etc/sysconfig/jenkins;\
    sed -i 's/-XX\:PermSize=256m //g' /etc/sysconfig/jenkins; \
    sed -i 's/-XX\:MaxPermSize=512m //g' /etc/sysconfig/jenkins;

COPY jenkins-init /usr/local/bin/jenkins-init

VOLUME /var/lib/jenkins

USER jenkins
WORKDIR /var/lib/jenkins

EXPOSE 8080

CMD jenkins-init
