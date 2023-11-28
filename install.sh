#!/bin/bash


function get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |                                            
    sed -E 's/.*"([^"]+)".*/\1/'                                    
}

function install_oh_my_bash() {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
}

function install_merlin_server() {
    local latest_version=$(get_latest_release Ne0nd0g/merlin)
    curl -kLO https://github.com/Ne0nd0g/merlin/releases/download/${latest_version}/merlinServer-Linux-x64.7z &&\
    7z x merlinServer-Linux-x64.7z -r merlinServer-Linux-x64 -pmerlin &&\
    install merlinServer-Linux-x64 /usr/local/bin/merlin-server &&\
    rm -rf merlinServer-Linux-x64*;
}

# https://merlin-c2.readthedocs.io/en/latest/agent/cli.html
function install_merlin_agent() {
    local latest_version=$(get_latest_release Ne0nd0g/merlin-agent)
    curl -kLO https://github.com/Ne0nd0g/merlin-agent/releases/download/${latest_version}/merlinAgent-Linux-x64.7z &&\
    7z x merlinAgent-Linux-x64.7z -r merlinAgent-Linux-x64 -pmerlin &&\
    install merlinAgent-Linux-x64 /usr/local/bin/merlin-agent &&\
    rm -rf merlinAgent-Linux-x64*;
}

function install_sliver() {
    local latest_version=$(get_latest_release BishopFox/sliver)
    curl -kLO https://github.com/BishopFox/sliver/releases/download/${latest_version}/sliver-client_linux &&\
    curl -kLO https://github.com/BishopFox/sliver/releases/download/${latest_version}/sliver-server_linux &&\
    install sliver-client_linux /usr/local/bin/sliver-client &&\
    install sliver-server_linux /usr/local/bin/sliver-server &&\
    rm -rf sliver-client_linux && rm -rf sliver-client_linux;
}

function install_posh_c2() {
    curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | sudo bash
}

install_oh_my_bash
install_merlin_server
install_merlin_agent
install_sliver
install_posh_c2
