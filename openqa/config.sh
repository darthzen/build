zypper -n ar --type='rpm-md' 'http://192.168.124.1/repo/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product' 'SLES12-SP1-Pool'
zypper -n mr --priority=99 'SLES12-SP1-Pool'

zypper -n ar --type='rpm-md' --refresh 'http://192.168.124.1/repo/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update' 'SLES12-SP1-Updates'
zypper -n mr --priority=99 'SLES12-SP1-Updates'

zypper -n ar --type='yast' 'http://192.168.124.1/install/SLES12-SP1-x86_64' 'SLES12-SP1-x86_64'
zypper -n mr --priority=99 'SLES12-SP1-x86_64'

zypper -n ar --type='rpm-md' 'http://192.168.124.1/repo/RPMMD/openQA-SLES-12-SP1' 'openQA'
zypper -n mr --priority=99 'openQA'

zypper -n ar --type='rpm-md' 'http://192.168.124.1/repo/RPMMD/openqa-perl_modules' 'openQA-perl_modules'
zypper -n mr --priority=99 'openQA-perl_modules'

zypper -n ar --type='rpm-md' 'http://192.168.124.1/repo/SUSE/Updates/SLE-Manager-Tools/12/x86_64/update' 'SLE-Manager-Tools'
zypper -n mr --priority=99 'SLE-Manager-Tools'

/usr/share/openqa/script/fetchneedles

exit 0
