zypper -n ar --type='rpm-md' 'http://192.168.124.1/repo/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product' 'SLES12-SP1-Pool'
zypper -n mr --priority=99 'SLES12-SP1-Pool'

zypper -n ar --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update' 'SLES12-SP1-Updates'
zypper -n mr --priority=99 'SLES12-SP1-Updates'

zypper -n ar --type='yast' 'http://192.168.124.1/install/SLES12-SP1-x86_64' 'SLES12-SP1-x86_64'
zypper -n mr --priority=99 'SLES12-SP1-x86_64'

zypper ar http://download.opensuse.org/repositories/Virtualization:/containers/SLE_12_SP1/Virtualization:containers.repo

systemctl enable kube-apiserver
systemctl enable kube-controller-manager
systemctl enable kube-scheduler
systemctl enable sshd

exit 0
