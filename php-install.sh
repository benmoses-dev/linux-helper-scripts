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
	print "PHP versions have not been installed..."
	print "Please run this script as root!"
	print "${COLOR_RESET}"
	exit 0
fi

print "${COLOR_YELLOW}"
print "Adding ondrej/php ppa to the system repositories"
print "${COLOR_RESET}"
apt update && apt install software-properties-common -y
add-apt-repository ppa:ondrej/php
apt update && apt upgrade -y

print "${COLOR_YELLOW}"
print "Installing PHP versions 8.0, 8.1 and 8.2, including all useful extensions"
print "${COLOR_RESET}"
apt install php8.1 php8.1-fpm php8.1-cli php8.1-imagick php8.1-intl php8.1-redis php8.1-yaml php8.1-zip -y
apt install php8.1-imap php8.1-mysql php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-xdebug -y

apt install php8.0 php8.0-fpm php8.0-mysql php8.0-xml -y
apt install php8.2 php8.2-fpm php8.2-mysql php8.2-xml -y

print "${COLOR_GREEN}"
print "Installation complete"
print "${COLOR_RESET}"
