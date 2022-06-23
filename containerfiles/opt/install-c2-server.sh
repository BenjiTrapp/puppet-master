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

function install_baby_shark() {
	cd /opt || return
	git clone https://github.com/danilovazb/BabyShark/
	cd BabyShark || return
	mkdir database
	sqlite3 database/c2.db < schema.sql
}

function install_enum4linux() {
	cd /opt || return
	git clone https://github.com/CiscoCXSecurity/enum4linux.git
	echo "alias enum4linux='/opt/enum4linux/./enum4linux.pl'" >> /root/.bashrc
}

function install_wordlists_and_rule_sets() {
	cd /opt || return
	git clone https://github.com/NotSoSecure/password_cracking_rules.git
	git clone https://github.com/praetorian-inc/Hob0Rules.git
	git clone https://github.com/danielmiessler/SecLists.git
}

function install_posh_c2() {
	cd /opt || return
	curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | bash
}

function install_ninja() {
	cd /opt || return
	git clone https://github.com/ahmedkhlief/Ninja/
	cd Ninja || return
	chmod +x ./install.sh 
	sudo ./install.sh
	python3 start_campaign.py
}

install_c2_server_over_apt
install_wordlists_and_rule_sets
install_posh_c2
install_enum4linux
#install_baby_shark
