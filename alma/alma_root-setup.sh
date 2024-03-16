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

dnf update -y

info "Installing System Software"
sleep 2

dnf install gnupg git python3-devel vim shellcheck tmux ripgrep fd-find xclip trash-cli multitail tree jq rsync -y
dnf install ca-certificates traceroute curl wget httpie -y
dnf install neofetch htop sl bat hyperfine exa mariadb-server nginx -y

systemctl enable --now nginx
sed -i 's/#server_tokens/server_tokens/g' /etc/nginx/nginx.conf
systemctl restart nginx

# install docker
# wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/docker-install.sh | bash

if [[ -z $(command -v docker) ]]; then
    error "Docker Not Installed!"
    sleep 1
fi

# install php
# wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/php-install.sh | bash

if [[ -z $(command -v php) ]]; then
    error "PHP Not Installed!"
    sleep 1
fi

success "System Software Install Finished!"
sleep 1
