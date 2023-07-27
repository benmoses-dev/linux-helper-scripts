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

if [[ "$EUID" -ne 0 ]]; then
	print "${COLOR_RED}"
	print "Docker has not been installed..."
	print "Please run this script as root!"
	print "${COLOR_RESET}"
	exit 0
fi

if [[ -n $(command -v docker) ]]; then
	print "${COLOR_RED}"
	print "Docker is already installed!"
	print "${COLOR_RESET}"
	sleep 1
else
	print "${COLOR_YELLOW}"
	print "Installing docker..."
	print "${COLOR_RESET}"
	sleep 1
	apt update && apt install curl gnupg -y
	mkdir -m 0755 -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo \
		"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
		tee /etc/apt/sources.list.d/docker.list >/dev/null
	chmod a+r /etc/apt/keyrings/docker.gpg
	apt update && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

	print "${COLOR_GREEN}"
	print "Docker Installed Successfully!"
	print "${COLOR_RESET}"
	sleep 1
fi
