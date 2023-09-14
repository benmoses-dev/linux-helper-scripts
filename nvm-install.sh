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

if [[ -z $(command -v curl) ]]; then
	error "NVM has not been installed..."
	error "Please install curl before running this script!"
    sleep 2
	exit 0
fi

info "Installing nvm, node, and npm"
sleep 2

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
sleep 1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install --lts

if [[ -n $(command -v node) ]]; then
    success "Node Installed Successfully!"
    sleep 1
else
    warning "Node Not Found On Path! You may need to log out and then in again..."
    sleep 1
fi

if [[ -n $(command -v npm) ]]; then
    success "NPM Installed Successfully!"
    sleep 1
else
    warning "NPM Not Found On Path! You may need to log out and then in again..."
    sleep 1
fi

if [[ -n $(command -v nvm) ]]; then
    success "NVM Installed Successfully!"
    sleep 1
else
    warning "NVM Not Found On Path! You may need to log out and then in again..."
    sleep 1
fi
