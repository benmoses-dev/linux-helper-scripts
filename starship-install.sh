#!/usr/bin/env bash

set -e

# Colours
COLOR_YELLOW=`tput setaf 3`
COLOR_RESET=`tput sgr0`
SILENT=false

print() {
    if [[ "${SILENT}" == false ]] ; then
        echo -e "$@"
    fi
}

mkdir -p "${HOME}"/.local/bin
mkdir -p "${HOME}"/.config/

print "${COLOR_YELLOW}"
print "installing starship"
print "${COLOR_RESET}"
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "${HOME}/.local/bin"

touch "${HOME}"/.config/starship.toml

wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship.toml > "${HOME}"/.config/starship.toml

echo 'export STARSHIP_CONFIG=$HOME/.config/starship.toml' >> "${HOME}"/.bashrc
echo 'eval "$(starship init bash)"' >> "${HOME}"/.bashrc

