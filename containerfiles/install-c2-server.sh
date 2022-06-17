#!/bin/bash

function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |                                            
    sed -E 's/.*"([^"]+)".*/\1/'                                    
}

#Install Enum4Linux"
cd /opt
git clone https://github.com/CiscoCXSecurity/enum4linux.git
echo "alias enum4linux='/opt/enum4linux/./enum4linux.pl'" >> /root/.bashrc

#Install PwnCat
cd /opt
git clone https://github.com/calebstewart/pwncat.git
cd pwncat 
python3 setup.py install

#Install Worldists & Rule Sets
cd /opt
git clone https://github.com/NotSoSecure/password_cracking_rules.git
git clone https://github.com/praetorian-inc/Hob0Rules.git
git clone https://github.com/danielmiessler/SecLists.git

#Install Powershell Empire & Starkiller GUI
cd /opt
git clone https://github.com/BC-SECURITY/Empire.git
cd Empire
./setup/install.sh
cd /opt

STARKILLER_VERSION=$(get_latest_release "BC-SECURITY/Starkiller")
wget https://github.com/BC-SECURITY/Starkiller/releases/download/"${STARKILLER_VERSION}"/starkiller-"${STARKILLER_VERSION:1}".AppImage
chmod +x starkiller-"${STARKILLER_VERSION:1}".AppImage

#Install PoshC2
cd /opt
curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | bash

#Install Impacket
cd /opt 
git clone https://github.com/SecureAuthCorp/impacket.git
/opt/impacket
pip3 install -r /opt/impacket/requirements.txt
python3 ./setup.py install
