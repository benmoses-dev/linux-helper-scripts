# linux-helper-scripts
### Collection of helper scripts for Linux and FreeBSD
### These scripts are not thoroughly tested and may not work

# Usage
## Complete desktop linux post install setup (from scratch)
```
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_desktop_root-setup.sh | sudo bash
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_user-setup.sh | bash
```
### Alternatively, download the two scripts, move to the directory containing the downloaded files, then:
```
chmod u+x ./ubuntu_2204_*
sudo ./ubuntu_2204_desktop_root-setup.sh
./ubuntu_2204_user-setup.sh
```
