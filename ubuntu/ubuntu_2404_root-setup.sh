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
	print "${COLOR_RED}"
	print "Please run this script as root!"
	print "${COLOR_RESET}"
    sleep 1
	exit 0
fi

info "Updating System..."
sleep 1

apt update && apt upgrade -y
snap refresh
apt autoremove -y

info "Installing System Software"
sleep 2

apt install gnupg git build-essential openjdk-17-jdk python3-dev python3-pip python3-venv mesa-utils-bin -y
apt install vim shellcheck tmux ripgrep fd-find xclip trash-cli multitail tree jq rsync fzf libfuse2 -y
apt install apt-transport-https ca-certificates inetutils-traceroute net-tools curl wget httpie -y
apt install neofetch htop cmatrix lolcat sl bat duf hyperfine hexyl eza -y
apt install mariadb-server nginx software-properties-common -y

systemctl enable --now nginx.service
sed -i 's/#server_tokens/server_tokens/g' /etc/nginx/nginx.conf
systemctl restart nginx.service

# install docker
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu/docker-install.sh | bash

if [[ -z $(command -v docker) ]]; then
    error "Docker Not Installed!"
    sleep 1
fi

# install php
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu/php-install.sh | bash

if [[ -z $(command -v php) ]]; then
    error "PHP Not Installed!"
    sleep 1
fi

success "System Software Install Finished!"
sleep 1
