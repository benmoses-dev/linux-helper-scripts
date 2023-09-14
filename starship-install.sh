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

if [[ -z $(command -v curl) ]] || [[ -z $(command -v wget) ]]; then
	error "Starship has not been installed..."
	error "Please install curl and wget before running this script!"
    sleep 1
	exit 0
fi

if [[ -n $(command -v starship) ]]; then
	error "Starship is already installed!"
	sleep 1
else
	mkdir -p "${HOME}/.local/bin"
	mkdir -p "${HOME}/.config"

	info "Installing starship"
	sleep 2
	curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "${HOME}/.local/bin"

	info "Configuring Starship"
	sleep 2
	wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship.toml >"${HOME}/.config/starship.toml"

	echo 'export STARSHIP_CONFIG=$HOME/.config/starship.toml' >>"${HOME}/.bashrc"
	echo 'eval "$(starship init bash)"' >>"${HOME}/.bashrc"

    if [[ -n $(command -v starship) || -f "${HOME}/.local/bin/starship" ]]; then
        success "Starship Installed Successfully!"
        sleep 1
    else
        error "Something went wrong - starship not found!"
        sleep 1
    fi
fi
