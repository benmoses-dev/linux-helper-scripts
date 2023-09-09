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

if [[ -z $(command -v curl) ]] || [[ -z $(command -v wget) ]]; then
	print "${COLOR_RED}"
	print "Starship has not been installed..."
	print "Please install curl and wget before running this script!"
	print "${COLOR_RESET}"
    sleep 1
	exit 0
fi

if [[ -n $(command -v starship) ]]; then
	print "${COLOR_RED}"
	print "Starship is already installed!"
	print "${COLOR_RESET}"
	sleep 1
else
	mkdir -p "${HOME}/.local/bin"
	mkdir -p "${HOME}/.config"

	print "${COLOR_YELLOW}"
	print "Installing starship"
	print "${COLOR_RESET}"
	sleep 2
	curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "${HOME}/.local/bin"

	print "${COLOR_YELLOW}"
	print "Configuring Starship"
	print "${COLOR_RESET}"
	sleep 2
	wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship.toml >"${HOME}/.config/starship.toml"

	echo 'export STARSHIP_CONFIG=$HOME/.config/starship.toml' >>"${HOME}/.bashrc"
	echo 'eval "$(starship init bash)"' >>"${HOME}/.bashrc"

    if [[ -n $(command -v starship) || -f "${HOME}/.local/bin/starship" ]]; then
        print "${COLOR_GREEN}"
        print "Starship Installed Successfully!"
        print "${COLOR_RESET}"
        sleep 1
    else
        print "${COLOR_RED}"
        print "Something went wrong - starship not found!"
        print "${COLOR_RESET}"
        sleep 1
    fi
fi
