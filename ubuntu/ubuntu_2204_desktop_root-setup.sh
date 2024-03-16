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
	error "Please run this script as root!"
    sleep 1
	exit 0
fi

showLogo() {
	info "Ubuntu Setup"
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
sleep 2

# install system software
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu/ubuntu_2204_root-setup.sh | bash

info "Installing Desktop Software"
sleep 2
apt update && apt install vlc filezilla gnome-tweaks libreoffice libreoffice-help-en-gb virt-manager -y

if [[ -n $(command -v syncthing) ]]; then
	error "Syncthing is already installed!"
	sleep 1
else
	info "Installing Syncthing"
	sleep 2

	curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
	printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | tee /etc/apt/preferences.d/syncthing
	apt update && apt install syncthing -y

    if [[ -n $(command -v syncthing) ]]; then
        success "Syncthing Installed Successfully!"
        sleep 1
    else
        error "Syncthing Not Found On Path!"
        sleep 1
    fi
fi

success "Desktop Software Install Finished!"
sleep 1
