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

showLogo() {
    print "${COLOR_YELLOW}"
    print "Ubuntu Setup"
    print "${COLOR_GREEN}"
    print " ___    _____   __  _  _  _______   ___    ____   "
    print "|   \  |  ___| / / | |/ /|__   __| / _ \  |  _ \  "
    print "| |\ \ | |___ | |  |   /    | |   / / \ \ | (_) | "
    print "| | | ||  ___| \ \ |   \    | |  | |   | || .__/  "
    print "| |/ / | |___   | || |\ \   | |   \ \_/ / | |     "
    print "|___/  |_____| /_/ |_| \_\  |_|    \___/  |_|     "
    print "                                                  "
    print "${COLOR_RESET}"
}

showLogo

print "${COLOR_YELLOW}"
print "updating system..."
print "${COLOR_RESET}"
apt update && apt upgrade -y
snap refresh
apt autoremove -y

print "${COLOR_YELLOW}"
print "installing software..."
print "${COLOR_RESET}"
apt install git build-essential openjdk-17-jdk tmux python-dev python-pip python3-dev python3-pip python3-neovim -y
apt install vlc vim ripgrep xclip trash-cli multitail tree jq rsync fzf libfuse2 -y
apt install neofetch htop cmatrix lolcat sl -y

print "${COLOR_YELLOW}"
print "installing snaps..."
print "${COLOR_RESET}"
snap install thunderbird
snap install starship --edge

print "${COLOR_YELLOW}"
print "installing syncthing"
print "${COLOR_RESET}"
apt install curl apt-transport-https ca-certificates -y
curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | tee /etc/apt/preferences.d/syncthing
apt update && apt install syncthing -y

print "${COLOR_YELLOW}"
print "installing docker..."
print "${COLOR_RESET}"
apt install gnupg -y
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg
apt update && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

cat << 'EOL' > ./ubuntu_2204_desktop_user-setup.sh
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
mkdir -p $HOME/.local/bin
wget -O $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x $HOME/.local/bin/nvim
mkdir -p $HOME/.local/share/nvim/site/pack/packer/start
git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone https://github.com/benmoses-dev/my-neovim.git $HOME/.config/nvim
EOL

print "${COLOR_GREEN}"
print "Done!"
print "${COLOR_RESET}"

print "${COLOR_YELLOW}"
echo "-------------------"
echo "Now run ubuntu_2204_desktop_user-setup.sh with user privileges..."
echo "-------------------"
print "${COLOR_RESET}"

chmod 755 "./ubuntu_2204_desktop_user-setup.sh"

