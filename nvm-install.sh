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

if [[ -z $(command -v curl) ]]; then
	print "${COLOR_RED}"
	print "NVM has not been installed..."
	print "Please install curl before running this script!"
	print "${COLOR_RESET}"
    sleep 2
	exit 0
fi

print "${COLOR_YELLOW}"
print "Installing nvm, node, and npm"
print "${COLOR_RESET}"
sleep 2

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
sleep 1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install --lts

if [[ -n $(command -v node) ]]; then
    print "${COLOR_GREEN}"
    print "Node Installed Successfully!"
    print "${COLOR_RESET}"
    sleep 1
else
    print "${COLOR_BLUE}"
    print "Node Not Found On Path! You may need to log out and then in again..."
    print "${COLOR_RESET}"
    sleep 1
fi

if [[ -n $(command -v npm) ]]; then
    print "${COLOR_GREEN}"
    print "NPM Installed Successfully!"
    print "${COLOR_RESET}"
    sleep 1
else
    print "${COLOR_BLUE}"
    print "NPM Not Found On Path! You may need to log out and then in again..."
    print "${COLOR_RESET}"
    sleep 1
fi

if [[ -n $(command -v nvm) ]]; then
    print "${COLOR_GREEN}"
    print "NVM Installed Successfully!"
    print "${COLOR_RESET}"
    sleep 1
else
    print "${COLOR_BLUE}"
    print "NVM Not Found On Path! You may need to log out and then in again..."
    print "${COLOR_RESET}"
    sleep 1
fi
