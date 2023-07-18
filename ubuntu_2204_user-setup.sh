#!/usr/bin/env bash

set -e

# Colours
COLOR_RED=`tput setaf 1`
COLOR_GREEN=`tput setaf 2`
COLOR_YELLOW=`tput setaf 3`
COLOR_BLUE=`tput setaf 4`
COLOR_RESET=`tput sgr0`
SILENT=false

print() {
    if [[ "${SILENT}" == false ]] ; then
        echo -e "$@"
    fi
}

mkdir -p $HOME/.local/bin

print "${COLOR_YELLOW}"
print "installing node"
print "${COLOR_RESET}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
sleep 3
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

print "${COLOR_YELLOW}"
print "installing rust"
print "${COLOR_RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

print "${COLOR_YELLOW}"
print "installing composer"
print "${COLOR_RESET}"
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
else
    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    echo $RESULT
fi
mv composer.phar $HOME/.local/bin/composer

print "${COLOR_YELLOW}"
print "installing starship"
print "${COLOR_RESET}"
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$HOME/.local/bin"

print "${COLOR_YELLOW}"
print "configuring bash"
print "${COLOR_RESET}"
mkdir -p $HOME/.config/
touch $HOME/.config/starship.toml
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship.toml > $HOME/starship.toml
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bashrc > $HOME/.bashrc
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bash_aliases > $HOME/.bash_aliases
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.profile > $HOME/.profile
echo 'export STARSHIP_CONFIG=$HOME/starship.toml' >> $HOME/.bashrc
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc

print "${COLOR_YELLOW}"
print "configuring tmux"
print "${COLOR_RESET}"
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/tmux-sessionizer > $HOME/.local/bin
chmod 755 $HOME/.local/bin/tmux-sessionizer
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.tmux.conf > $HOME/.tmux.conf

print "${COLOR_YELLOW}"
print "configuring vim and neovim"
print "${COLOR_RESET}"

# legacy vim setup
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.vimrc > $HOME/.vimrc
mkdir -p $HOME/.vim/pack/plugins/start
mkdir -p $HOME/.vim/pack/plugins/opt
git clone https://github.com/preservim/nerdtree.git $HOME/.vim/pack/plugins/start/nerdtree
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/nerdtree/doc" -c q
git clone https://github.com/vim-airline/vim-airline $HOME/.vim/pack/plugins/start/vim-airline
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/vim-airline/doc" -c q
git clone https://github.com/airblade/vim-gitgutter.git $HOME/.vim/pack/plugins/start/vim-gitgutter
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/vim-gitgutter/doc" -c q

# neovim setup
wget -O $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x $HOME/.local/bin/nvim
mkdir -p $HOME/.local/share/nvim/site/pack/packer/start
git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/benmoses-dev/my-neovim.git $HOME/.config/nvim
npm install -g neovim
npm install -g tree-sitter-cli

