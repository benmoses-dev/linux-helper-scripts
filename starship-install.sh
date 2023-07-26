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
	print "Starship not installed..."
	print "Please install curl before running this script!"
	print "${COLOR_RESET}"
	exit 0
fi

if [[ -n $(command -v starship) ]]; then
	print "${COLOR_RED}"
	print "Starship already installed!"
	print "${COLOR_RESET}"
else
	mkdir -p "${HOME}/.local/bin"
	mkdir -p "${HOME}/.config"

	print "${COLOR_YELLOW}"
	print "Installing starship"
	print "${COLOR_RESET}"
	curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "${HOME}/.local/bin"

	touch "${HOME}/.config/starship.toml"
	wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship.toml >"${HOME}/.config/starship.toml"

	echo 'export STARSHIP_CONFIG=$HOME/.config/starship.toml' >>"${HOME}/.bashrc"
	echo 'eval "$(starship init bash)"' >>"${HOME}/.bashrc"

	print "${COLOR_GREEN}"
	print "Starship installed successfully!"
	print "${COLOR_RESET}"
fi
