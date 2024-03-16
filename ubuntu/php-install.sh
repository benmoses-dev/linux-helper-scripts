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

success() {
    print "${COLOR_GREEN}"
    print "${1}"
    print "${COLOR_RESET}"
}

if [[ "$EUID" -ne 0 ]]; then
	error "PHP versions have not been installed..."
	error "Please run this script as root!"
    sleep 1
	exit 0
fi

if [[ -z $(find /etc/apt -type f -iname "ondrej-ubuntu-php*") ]]; then
	info "Adding ondrej/php ppa to the system repositories"
    sleep 2
	apt update && apt install software-properties-common -y
	add-apt-repository ppa:ondrej/php
fi

apt update && apt upgrade -y

info "Installing PHP versions 8.0, 8.1, 8,2 and 8.3, including all useful extensions"
sleep 2

PHPVER="8.0"
apt install php${PHPVER} php${PHPVER}-fpm php${PHPVER}-cli php${PHPVER}-imagick php${PHPVER}-intl php${PHPVER}-redis php${PHPVER}-yaml php${PHPVER}-zip php${PHPVER}-gnupg -y
apt install php${PHPVER}-imap php${PHPVER}-mysql php${PHPVER}-gd php${PHPVER}-mbstring php${PHPVER}-curl php${PHPVER}-xml php${PHPVER}-bcmath php${PHPVER}-xdebug php${PHPVER}-pgsql -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/${PHPVER}/mods-available/xdebug.ini"

PHPVER="8.1"
apt install php${PHPVER} php${PHPVER}-fpm php${PHPVER}-cli php${PHPVER}-imagick php${PHPVER}-intl php${PHPVER}-redis php${PHPVER}-yaml php${PHPVER}-zip php${PHPVER}-gnupg -y
apt install php${PHPVER}-imap php${PHPVER}-mysql php${PHPVER}-gd php${PHPVER}-mbstring php${PHPVER}-curl php${PHPVER}-xml php${PHPVER}-bcmath php${PHPVER}-xdebug php${PHPVER}-pgsql -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/${PHPVER}/mods-available/xdebug.ini"

PHPVER="8.2"
apt install php${PHPVER} php${PHPVER}-fpm php${PHPVER}-cli php${PHPVER}-imagick php${PHPVER}-intl php${PHPVER}-redis php${PHPVER}-yaml php${PHPVER}-zip php${PHPVER}-gnupg -y
apt install php${PHPVER}-imap php${PHPVER}-mysql php${PHPVER}-gd php${PHPVER}-mbstring php${PHPVER}-curl php${PHPVER}-xml php${PHPVER}-bcmath php${PHPVER}-xdebug php${PHPVER}-pgsql -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/${PHPVER}/mods-available/xdebug.ini"

PHPVER="8.3"
apt install php${PHPVER} php${PHPVER}-fpm php${PHPVER}-cli php${PHPVER}-imagick php${PHPVER}-intl php${PHPVER}-redis php${PHPVER}-yaml php${PHPVER}-zip php${PHPVER}-gnupg -y
apt install php${PHPVER}-imap php${PHPVER}-mysql php${PHPVER}-gd php${PHPVER}-mbstring php${PHPVER}-curl php${PHPVER}-xml php${PHPVER}-bcmath php${PHPVER}-xdebug php${PHPVER}-pgsql -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/${PHPVER}/mods-available/xdebug.ini"

success "PHP Installation complete"
sleep 1
