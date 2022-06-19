#!/bin/bash

function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |                                            
    sed -E 's/.*"([^"]+)".*/\1/'                                    
}


function install_c2_server_over_apt() {
	apt-get install -y 	powershell-empire \
						starkiller \
						merlin-server
}
#Install Enum4Linux"
cd /opt
git clone https://github.com/CiscoCXSecurity/enum4linux.git
echo "alias enum4linux='/opt/enum4linux/./enum4linux.pl'" >> /root/.bashrc

#Install Worldists & Rule Sets
cd /opt
git clone https://github.com/NotSoSecure/password_cracking_rules.git
git clone https://github.com/praetorian-inc/Hob0Rules.git
git clone https://github.com/danielmiessler/SecLists.git

#Install BabyShark
git clone https://github.com/danilovazb/BabyShark/
cd BabyShark
mkdir database
sqlite3 database/c2.db < schema.sql

#Install PoshC2
cd /opt
curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | bash

#Install ninja2
cd /opt
git clone https://github.com/ahmedkhlief/Ninja/
chmod +x ./install.sh sudo ./install.sh
python3 start_campaign.py
