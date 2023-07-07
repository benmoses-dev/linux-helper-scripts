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
apt install git build-essential openjdk-17-jdk tmux -y
apt install vlc vim trash-cli multitail tree jq rsync -y
apt install neofetch cmatrix lolcat sl -y

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
print "configuring bash"
print "${COLOR_RESET}"
mkdir -p $HOME/.config/
touch $HOME/.config/starship.toml
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/starship.toml > $HOME/starship.toml
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bashrc > $HOME/.bashrc
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.bash_aliases > $HOME/.bash_aliases
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.profile > $HOME/.profile
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/.vimrc > $HOME/.vimrc
echo 'export STARSHIP_CONFIG=$HOME/starship.toml' >> $HOME/.bashrc
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
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

