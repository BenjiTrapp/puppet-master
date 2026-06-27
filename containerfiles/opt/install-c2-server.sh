#!/bin/bash

function get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

function install_c2_server_over_apt() {
	apt-get update

	# Install available Kali C2 packages; individual failures are non-fatal
	# so a missing/renamed package doesn't abort the whole build
	for pkg in powershell-empire starkiller merlin-server havoc sliver; do
		apt-get install -y --no-install-recommends "$pkg" || \
			echo "[WARN] $pkg not available via apt, skipping"
	done
}

function install_sliver_binary() {
	# Fallback: install Sliver from upstream release if apt package is unavailable
	# Asset names changed in v1.5+ from sliver-*_linux to sliver-*_linux-amd64
	local latest_version
	latest_version=$(get_latest_release BishopFox/sliver)
	curl -kLO "https://github.com/BishopFox/sliver/releases/download/${latest_version}/sliver-client_linux-amd64" &&\
	curl -kLO "https://github.com/BishopFox/sliver/releases/download/${latest_version}/sliver-server_linux-amd64" &&\
	install sliver-client_linux-amd64 /usr/local/bin/sliver-client &&\
	install sliver-server_linux-amd64 /usr/local/bin/sliver-server &&\
	rm -f sliver-client_linux-amd64 sliver-server_linux-amd64
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
	# Python 3.12+ marks the environment as externally managed; remove the guard
	# so pip can install packages during the PoshC2 bootstrap in Docker
	find /usr/lib/python3.* -name EXTERNALLY-MANAGED -delete 2>/dev/null || true
	curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | bash
}

install_c2_server_over_apt

# Ensure sliver binaries are present even if apt package failed
if ! command -v sliver-server &>/dev/null; then
	echo "[INFO] Installing Sliver from upstream release..."
	install_sliver_binary
fi

install_wordlists_and_rule_sets
install_posh_c2
install_enum4linux
#install_baby_shark
