#!/usr/bin/env bash

set -e

# Colours
COLOR_GREEN=`tput setaf 2`
COLOR_YELLOW=`tput setaf 3`
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
apt install vlc

print "${COLOR_YELLOW}"
print "installing syncthing"
print "${COLOR_RESET}"
apt install curl apt-transport-https ca-certificates -y
curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | tee /etc/apt/preferences.d/syncthing
apt update && apt install syncthing -y

print "${COLOR_GREEN}"
print "Done!"
print "${COLOR_RESET}"

