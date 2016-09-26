zypper -n ar --type='rpm-md' 'http://192.168.124.1/repo/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product' 'SLES12-SP1-Pool'
zypper -n mr --priority=99 'SLES12-SP1-Pool'

zypper -n ar --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update' 'SLES12-SP1-Updates'
zypper -n mr --priority=99 'SLES12-SP1-Updates'

zypper -n ar --type='yast' 'http://192.168.124.1/install/SLES12-SP1-x86_64' 'SLES12-SP1-x86_64'
zypper -n mr --priority=99 'SLES12-SP1-x86_64'

zypper -n ar --type='yast' 'http://192.168.124.1/install/SUSE-Cloud-6' 'Cloud'
zypper -n mr --priority=99 'Cloud'

zypper -n ar --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/OpenStack-Cloud/6/x86_64/update' 'Cloud-Updates'
zypper -n mr --priority=99 'Cloud-Updates'

echo "192.168.124.1:/exports/msata/smt /srv/www/htdocs/repo nfs ro 1 2" >> /etc/fstab

systemctl enable sshd

exit 0
