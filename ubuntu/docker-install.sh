#!/usr/bin/env bash

set -e

# Colours
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
COLOR_RESET=$(tput sgr0)
SILENT=false

print() {
	if [[ "${SILENT}" == false ]]; then
		echo -e "$@"
	fi
}

error() {
    print "${COLOR_RED}"
    print "${1}"
    print "${COLOR_RESET}"
}

info() {
    print "${COLOR_YELLOW}"
    print "${1}"
    print "${COLOR_RESET}"
}

warning() {
    print "${COLOR_BLUE}"
    print "${1}"
    print "${COLOR_RESET}"
}

success() {
    print "${COLOR_GREEN}"
    print "${1}"
    print "${COLOR_RESET}"
}

if [[ "$EUID" -ne 0 ]]; then
	error "Docker has not been installed..."
	error "Please run this script as root!"
    sleep 1
	exit 0
fi

if [[ -n $(command -v docker) ]]; then
	warning "Docker is already installed!"
	sleep 1
else
	info "Installing docker..."
	sleep 2
	apt update && apt install curl gnupg -y
	mkdir -m 0755 -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo \
		"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
		tee /etc/apt/sources.list.d/docker.list >/dev/null
	chmod a+r /etc/apt/keyrings/docker.gpg
	apt update && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    if [[ -n $(command -v docker) ]]; then
        success "Docker Installed Successfully!"
        sleep 1
    else
        error "Docker Not Found On Path!"
        sleep 1
    fi
fi
