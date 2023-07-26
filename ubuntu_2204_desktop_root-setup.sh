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
	print "Please run this script as root!"
	print "${COLOR_RESET}"
	exit 0
fi

showLogo() {
	print "${COLOR_YELLOW}"
	print "Ubuntu Setup"
	print "${COLOR_BLUE}"
	print " ___    _____   __  _  _  _______   ___    ____   "
	print "|   \  |  ___| / / | |/ /|__   __| / _ \  |  _ \  "
	print "| |\ \ | |___ | |  |   /    | |   / / \ \ | (_) | "
	print "| | | ||  ___| \ \ |   \    | |  | |   | || .__/  "
	print "| |/ / | |___   | || |\ \   | |   \ \_/ / | |     "
	print "|___/  |_____| /_/ |_| \_\  |_|    \___/  |_|     "
	print "                                                  "
	print "${COLOR_RESET}"
}

showLogo

# call root script here

apt update && apt install vlc -y

print "${COLOR_YELLOW}"
print "Installing Syncthing"
print "${COLOR_RESET}"
curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | tee /etc/apt/preferences.d/syncthing
apt update && apt install syncthing -y

print "${COLOR_GREEN}"
print "Syncthing Installed Successfully!"
print "${COLOR_RESET}"

print "${COLOR_GREEN}"
print "All Software Installed Successfully!"
print "${COLOR_RESET}"
