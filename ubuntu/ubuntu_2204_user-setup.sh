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

if [[ -z $(command -v curl) ]] || [[ -z $(command -v wget) ]]; then
	error "Please install curl and wget before running this script!"
    sleep 1
	exit 0
fi

if [[ -z $(command -v git) ]]; then
	error "Please install git before running this script!"
    sleep 1
	exit 0
fi

mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.config"

info "Configuring bash"
sleep 2

wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bash_aliases >"${HOME}/.bash_aliases"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.profile >"${HOME}/.profile"

echo 'export EDITOR=nvim' >>"${HOME}/.bashrc"
echo 'export FZF_DEFAULT_COMMAND="fdfind --hidden --no-ignore --exclude **/.git/*"' >>"${HOME}/.bashrc"
echo 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"' >>"${HOME}/.bashrc"

info "Installing rust"
sleep 2

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install nvm, node, and npm
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/nvm-install.sh | bash

# install composer
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/composer-install.sh | bash

info "Installing web server automation script"
sleep 2

wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu/setup-site >"${HOME}/.local/bin/setup-site"
chmod 755 "${HOME}/.local/bin/setup-site"

info "Configuring tmux"
sleep 2

wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu/tmux-sessionizer >"${HOME}/.local/bin/tmux-sessionizer"
chmod 755 "${HOME}/.local/bin/tmux-sessionizer"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.tmux.conf >"${HOME}/.tmux.conf"

info "Configuring vim and neovim"
sleep 2

# legacy vim config
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.vimrc >"${HOME}/.vimrc"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.ideavimrc >"${HOME}/.ideavimrc"

# neovim setup
if [[ -n $(command -v nvim) ]]; then
	error "Neovim is already installed!"
	sleep 1
else
	if [[ ! -f "${HOME}/.local/bin/nvim" ]]; then
		wget --quiet -O "${HOME}/.local/bin/nvim" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
		chmod u+x "${HOME}/.local/bin/nvim"
	fi
	if [[ ! -d "${HOME}/.config/nvim" ]]; then
		git clone https://github.com/benmoses-dev/my-neovim.git "${HOME}/.config/nvim"
	fi
	if [[ -n $(command -v npm) ]]; then
		npm install -g neovim
		npm install -g tree-sitter-cli
	fi

	success "Neovim installed successfully!"
	warning "Consider moving the binary to /usr/local/bin if you have root privileges..."
	sleep 2
fi

# install starship
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship-install.sh | bash

success "User software installed successfully!"
sleep 1
