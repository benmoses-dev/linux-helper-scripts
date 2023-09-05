# linux-helper-scripts
### Collection of helper scripts for Linux and FreeBSD
### These scripts are not thoroughly tested and may not work

# Usage
## Desktop Ubuntu
```
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_desktop_root-setup.sh | sudo bash
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_user-setup.sh | bash
```
### Alternatively, download the two scripts:
```
wget https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_desktop_root-setup.sh
wget https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_user-setup.sh
```
### Then:
```
chmod u+x ./ubuntu_2204_*
sudo ./ubuntu_2204_desktop_root-setup.sh
./ubuntu_2204_user-setup.sh
```
## Windows Subsystem for Linux (Ubuntu, with systemd enabled) or Ubuntu Server
```
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_root-setup.sh | sudo bash
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_user-setup.sh | bash
```
### Alternatively, download the two scripts:
```
wget https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_root-setup.sh
wget https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_user-setup.sh
```
### Then:
```
chmod u+x ./ubuntu_2204_*
sudo ./ubuntu_2204_root-setup.sh
./ubuntu_2204_user-setup.sh
```
