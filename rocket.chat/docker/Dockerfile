FROM suse/sles12sp2:latest

MAINTAINER Rick Ashford <rick.ashford@suse.com>

RUN zypper --non-interactive remove container-suseconnect; \
    zypper addrepo -t yast2 http://172.17.0.1/install/SLES12-SP2-x86_64 SLES12-SP2-x86_64; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update SLES12-SP2-x86_64-Updates; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Products/SLE-SDK/12-SP2/x86_64/product SLE-SDK; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-SDK/12-SP2/x86_64/update SLE-SDK-Updates; \ 
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Products/SLE-Module-Web-Scripting/12/x86_64/product SLE-Module-Web-Scripting; \
    zypper addrepo -t rpm-md http://172.17.0.1/repo/SUSE/Updates/SLE-Module-Web-Scripting/12/x86_64/update SLE-Module-Web-Scripting-Updates; \
    zypper addrepo -t rpm-md http://download.opensuse.org/repositories/home:/darthzen:/branches:/graphics/SLE_12_SP2/ darthzen:branches:graphics; \
    zypper addrepo -t rpm-md http://download.opensuse.org/repositories/devel:/libraries:/c_c++/SLE_12_SP2/ devel:libraries:c_c++; \
    zypper --non-interactive --gpg-auto-import-keys update --auto-agree-with-licenses; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses python; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses -t pattern Basis-Devel SDK-C-C++; \
    zypper --non-interactive --gpg-auto-import-keys install --auto-agree-with-licenses --recommends apache2 nodejs4 npm4 GraphicsMagick curl; \
    cd /tmp; \
    npm install bcrypt; \
    npm install -g meteor-promise fibers promise underscore source-map-support semver node-gyp node-pre-gyp eachline chalk; \
    cd /; \
    rm -Rf /tmp/*; \
    ROCKETVERS=`curl https://raw.githubusercontent.com/RocketChat/Rocket.Chat/develop/packages/rocketchat-lib/rocketchat.info|grep "\"version\""|cut -d : -f 2 | sed 's/[\",]//g'`; \
    mkdir -p /srv/www/rocket.chat/uploads; \
    curl -L https://rocket.chat/releases/latest/download | tar -zxv -C /srv/www/rocket.chat/ --strip-components=1; \
    cd /srv/www/rocket.chat/programs/server; \
    npm install; \
    npm cache clear; \
    groupadd -r rocketchat; \
    useradd -r -g rocketchat rocketchat; \
    chown -R rocketchat:rocketchat /srv/www/rocket.chat; \ 
    systemctl enable apache2 rocketchat; \
    echo "VERSION ${ROCKETVERS} BUILD SUCCESSFUL"

ADD rocketchat.conf /etc/apache2/vhosts.d/rocketchat.conf

USER rocketchat

VOLUME /srv/www/rocket.chat/uploads

ENV MONGO_URL=mongodb://mongo:27017/rocketchat \
    MONGO_OPLOG_URL=mongodb://mongo:27017/local \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 443

CMD [ "/sbin/init" ]
