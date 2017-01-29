#!/bin/bash
# Copyright (c) 2015 SUSE LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

# mkdir /var/lib/named
# mkdir /var/lib/pgsql
# mkdir /var/lib/mailman
# mkdir /boot/grub2/i386-pc

mkdir /var/lib/misc/reconfig_system

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$name]..."

#======================================
# add missing fonts
#--------------------------------------
CONSOLE_FONT="lat9w-16.psfu"

#======================================
# prepare for setting root pw, timezone
#--------------------------------------
echo ** "reset machine settings"
sed -i 's/^root:[^:]*:/root:*:/' /etc/shadow
rm /etc/machine-id
rm /etc/localtime
rm /var/lib/zypp/AnonymousUniqueId
rm /var/lib/systemd/random-seed

#======================================
# SuSEconfig
#--------------------------------------
echo "** Running suseConfig..."
suseConfig

echo "** Running ldconfig..."
/sbin/ldconfig

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Specify default runlevel
#--------------------------------------
baseSetRunlevel 3

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

#======================================
# Firewall Configuration
#--------------------------------------
echo '** Configuring firewall...'
chkconfig SuSEfirewall2_init on
chkconfig SuSEfirewall2_setup on

#======================================
# Enable sshd
#--------------------------------------
chkconfig sshd on

#======================================
# Remove doc files
#--------------------------------------
baseStripDocs

#======================================
# remove rpms defined in config.xml in the image type=delete section 
#--------------------------------------
baseStripRPM

#======================================
# Sysconfig Update
#--------------------------------------
echo '** Update sysconfig entries...'
baseUpdateSysConfig /etc/sysconfig/SuSEfirewall2 FW_CONFIGURATIONS_EXT sshd
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_FONT "$CONSOLE_FONT"
# baseUpdateSysConfig /etc/sysconfig/snapper SNAPPER_CONFIGS root
if [ "${kiwi_iname##*-for-}" != "OpenStack-Cloud" ]; then
	baseUpdateSysConfig /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME yes
fi

# true
#======================================
# SSL Certificates Configuration
#--------------------------------------
echo '** Rehashing SSL Certificates...'
update-ca-certificates

if [ ! -s /var/log/zypper.log ]; then
	> /var/log/zypper.log
fi

# only for debugging

#systemctl enable debug-shell.service

# Set repos

rm -f /etc/zypp/repos.d/*

zypper addrepo -t yast2 http://192.168.7.1/install/suse/SLES12-SP2-x86_64 SLES12-SP2-x86_64
zypper addrepo -t rpm-md -f http://192.168.7.1/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update
zypper addrepo -t rpm-md http://192.168.7.1/repo/SUSE/Products/SLE-Module-Web-Scripting/12/x86_64/product SLE-Module-Web-Scripting
zypper addrepo -t rpm-md -f http://192.168.7.1/repo/SUSE/Updates/SLE-Module-Web-Scripting/12/x86_64/update SLE-Module-Web-Scripting-Updates
zypper addrepo -t rpm-md http://192.168.7.1/repo/SUSE/Products/SLE-SDK/12-SP2/x86_64/product SLE-SDK
zypper addrepo -t rpm-md -f http://192.168.7.1/repo/SUSE/Updates/SLE-SDK/12-SP2/x86_64/update SLE-SDK-Update
zypper addrepo -t rpm-md http://192.168.7.1/repo/SUSE/Products/SLE-Module-Adv-Systems-Management/12/x86_64/product SLE-Module-Adv-Systems-Management
zypper addrepo -t rpm-md -f http://192.168.7.1/repo/SUSE/Updates/SLE-Module-Adv-Systems-Management/12/x86_64/update SLE-Module-Adv/Systems-Management-Updates

# Install Rocket.Chat
cd /opt/rocket.chat
ROCKETVERS=`grep "\"version\":" bundle/programs/server/packages/rocketchat_lib.js|cut -d : -f 2 | sed 's/[\",]//g'`
mv -fv bundle $ROCKETVERS
ln -sf $ROCKETVERS app
cd /opt/rocket.chat/app/programs/server

npm install -g meteor-promise fibers promise underscore source-map-support semver node-gyp node-pre-gyp eachline chalk bcrypt
npm install --unsafe-perm

baseCleanMount

exit 0
