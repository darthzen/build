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


baseMount

#======================================
# add missing fonts
#--------------------------------------
CONSOLE_FONT="lat9w-16.psfu"

#======================================
# prepare for setting root pw, timezone
#--------------------------------------
echo ** "reset machine settings"
#sed -i 's/^root:[^:]*:/root:*:/' /etc/shadow
rm /etc/machine-id
#rm /etc/localtime
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

if [ ! -s /var/log/zypper.log ]; then
	> /var/log/zypper.log
fi

# Set repos

rm -f /etc/zypp/repos.d/*

zypper addrepo --type='rpm-md' 'http://192.168.124.1/repo/SUSE/Products/SLE-SERVER/12-SP2/x86_64/product' 'SLES12-SP2-Pool'
zypper addrepo --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update' 'SLES12-SP2-Updates'
zypper addrepo --type='yast' 'http://192.168.124.1/install/SLES12-SP2-x86_64' 'SLES12-SP2-x86_64'

zypper addrepo --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Products/SLE-Module-Adv-Systems-Management/12/x86_64/product' 'SLE-Modue-Adv-Systems-Management'
zypper addrepo --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/SLE-Module-Adv-Systems-Management/12/x86_64/update' 'SLE-Modue-Adv-Systems-Management-Updates'

zypper addrepo --type='yast' 'http://192.168.124.1/install/SUSE-Cloud-7' 'Cloud'
zypper addrepo --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/OpenStack-Cloud/7/x86_64/update' 'Cloud-Updates'

zypper addrepo --type='rpm-md' 'http://192.168.124.1/utilities' 'Utilities'

echo "192.168.124.1:/exports/msata/smt /srv/www/htdocs/repo nfs ro 1 2" >> /etc/fstab

systemctl enable sshd

mkdir -p /.snapshots /boot/grub2/{x86_64-efi,i386-pc} /var/{opt,log,lib,crash,tmp,spool} /var/lib/{pgsql,mailman,named} /tmp /srv /home

baseCleanMount

exit 0
