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
	print "Please install curl before running this script!"
	print "${COLOR_RESET}"
	exit 0
fi

if [[ -z $(command -v git) ]]; then
	print "${COLOR_RED}"
	print "Please install git before running this script!"
	print "${COLOR_RESET}"
	exit 0
fi

mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.config"

print "${COLOR_YELLOW}"
print "Configuring bash"
print "${COLOR_RESET}"

wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bashrc >"${HOME}/.bashrc"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bash_aliases >"${HOME}/.bash_aliases"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.profile >"${HOME}/.profile"

print "${COLOR_YELLOW}"
print "Installing rust"
print "${COLOR_RESET}"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# call nvm install here
# call composer install here

print "${COLOR_YELLOW}"
print "Configuring tmux"
print "${COLOR_RESET}"

wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/tmux-sessionizer >"${HOME}/.local/bin/tmux-sessionizer"
chmod 755 "${HOME}/.local/bin/tmux-sessionizer"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.tmux.conf >"${HOME}/.tmux.conf"

print "${COLOR_YELLOW}"
print "Configuring vim and neovim"
print "${COLOR_RESET}"

# legacy vim config
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.vimrc >"${HOME}/.vimrc"

# neovim setup
if [[ -n $(command -v nvim) ]]; then
	print "${COLOR_RED}"
	print "Neovim is already installed!"
	print "${COLOR_RESET}"
else
    if [[ ! -f "${HOME}/.local/bin/nvim" ]]; then
	    wget -O "${HOME}/.local/bin/nvim" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	    chmod u+x "${HOME}/.local/bin/nvim"
    fi
    mkdir -p "${HOME}/.local/share/nvim/site/pack/packer/start"
    if [[ ! -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
	    git clone --depth 1 https://github.com/wbthomason/packer.nvim "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
    fi
    if [[ ! -d "${HOME}/.config/nvim" ]]; then
	    git clone https://github.com/benmoses-dev/my-neovim.git "${HOME}/.config/nvim"
    fi
    npm install -g neovim
    npm install -g tree-sitter-cli

    print "${COLOR_GREEN}"
    print "Neovim installed successfully!"
    print "${COLOR_BLUE}"
    print "Consider moving the binary to /usr/local/bin if you have root privileges..."
    print "${COLOR_RESET}"
fi

# call starship install here

print "${COLOR_GREEN}"
print "User software installed successfully!"
print "${COLOR_RESET}"
