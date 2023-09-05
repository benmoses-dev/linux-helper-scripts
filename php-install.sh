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

if [[ -z $(find /etc/apt -type f -iname "ondrej-ubuntu-php*") ]]; then
	print "${COLOR_YELLOW}"
	print "Adding ondrej/php ppa to the system repositories"
	print "${COLOR_RESET}"
	apt update && apt install software-properties-common -y
	add-apt-repository ppa:ondrej/php
fi

apt update && apt upgrade -y

print "${COLOR_YELLOW}"
print "Installing PHP versions 7.3, 7.4, 8.0, 8.1 and 8.2, including all useful extensions"
print "${COLOR_RESET}"

apt install php7.3 php7.3-fpm php7.3-cli php7.3-imagick php7.3-intl php7.3-redis php7.3-yaml php7.3-zip php7.3-gnupg -y
apt install php7.3-imap php7.3-mysql php7.3-gd php7.3-mbstring php7.3-curl php7.3-xml php7.3-bcmath php7.3-xdebug -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/7.3/mods-available/xdebug.ini"

apt install php7.4 php7.4-fpm php7.4-cli php7.4-imagick php7.4-intl php7.4-redis php7.4-yaml php7.4-zip php7.4-gnupg -y
apt install php7.4-imap php7.4-mysql php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath php7.4-xdebug -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/7.4/mods-available/xdebug.ini"

apt install php8.0 php8.0-fpm php8.0-cli php8.0-imagick php8.0-intl php8.0-redis php8.0-yaml php8.0-zip php8.0-gnupg -y
apt install php8.0-imap php8.0-mysql php8.0-gd php8.0-mbstring php8.0-curl php8.0-xml php8.0-bcmath php8.0-xdebug -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/8.0/mods-available/xdebug.ini"

apt install php8.1 php8.1-fpm php8.1-cli php8.1-imagick php8.1-intl php8.1-redis php8.1-yaml php8.1-zip php8.1-gnupg -y
apt install php8.1-imap php8.1-mysql php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-xdebug -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/8.1/mods-available/xdebug.ini"

apt install php8.2 php8.2-fpm php8.2-cli php8.2-imagick php8.2-intl php8.2-redis php8.2-yaml php8.2-zip php8.2-gnupg -y
apt install php8.2-imap php8.2-mysql php8.2-gd php8.2-mbstring php8.2-curl php8.2-xml php8.2-bcmath php8.2-xdebug -y
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/xdebug3.ini >"/etc/php/8.2/mods-available/xdebug.ini"

print "${COLOR_GREEN}"
print "Installation complete"
print "${COLOR_RESET}"
