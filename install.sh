#!/bin/bash

function get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

function install_merlin_server() {
	local latest_version
	latest_version=$(get_latest_release Ne0nd0g/merlin)
	curl -kLO "https://github.com/Ne0nd0g/merlin/releases/download/${latest_version}/merlinServer-Linux-x64.7z" &&\
	7z x merlinServer-Linux-x64.7z -r merlinServer-Linux-x64 -pmerlin &&\
	install merlinServer-Linux-x64 /usr/local/bin/merlin-server &&\
	rm -rf merlinServer-Linux-x64*
}

function install_merlin_agent() {
	local latest_version
	latest_version=$(get_latest_release Ne0nd0g/merlin-agent)
	curl -kLO "https://github.com/Ne0nd0g/merlin-agent/releases/download/${latest_version}/merlinAgent-Linux-x64.7z" &&\
	7z x merlinAgent-Linux-x64.7z -r merlinAgent-Linux-x64 -pmerlin &&\
	install merlinAgent-Linux-x64 /usr/local/bin/merlin-agent &&\
	rm -rf merlinAgent-Linux-x64*
}

function install_sliver() {
	local latest_version
	latest_version=$(get_latest_release BishopFox/sliver)
	# Asset names changed in v1.5+ from sliver-*_linux to sliver-*_linux-amd64
	curl -kLO "https://github.com/BishopFox/sliver/releases/download/${latest_version}/sliver-client_linux-amd64" &&\
	curl -kLO "https://github.com/BishopFox/sliver/releases/download/${latest_version}/sliver-server_linux-amd64" &&\
	install sliver-client_linux-amd64 /usr/local/bin/sliver-client &&\
	install sliver-server_linux-amd64 /usr/local/bin/sliver-server &&\
	rm -f sliver-client_linux-amd64 sliver-server_linux-amd64
}

function install_posh_c2() {
	# Python 3.12+ marks the environment as externally managed; remove the guard
	# so pip can install packages during the PoshC2 bootstrap in Docker
	find /usr/lib/python3.* -name EXTERNALLY-MANAGED -delete 2>/dev/null || true
	curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | bash
}

install_merlin_server
install_merlin_agent
install_sliver
install_posh_c2
