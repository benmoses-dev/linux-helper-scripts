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
    print "  __  _____  ____  __       __ _____  ____   "
    print " / / |  ___||    \ \ \     / /| ____||    \  "
    print "| |  | |___ | () |  \ \   / / | |___ | () |  "
    print " \ \ |  ___||    /   \ \ / /  |  ___||    /  "
    print "  | || |___ | |\ \    \ v /   | |___ | |\ \  "
    print " /_/ |_____||_| \_\    \_/    |_____|| | \_\ "
    print "                                             "
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
apt install git build-essential openjdk-17-jdk tmux python3-dev python3-pip -y
apt install vim ripgrep fd-find xclip trash-cli multitail tree jq rsync fzf libfuse2 neofetch htop -y
apt install mariadb-server nginx -y
apt install php php-fpm php-cli php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath -y

print "${COLOR_YELLOW}"
print "installing snaps..."
print "${COLOR_RESET}"

systemctl enable --now php8.1-fpm
systemctl enable --now nginx

cat << 'EOL' > /etc/nginx/sites-available/default
server {
         listen       80;
         server_name  example.com;
         root         /var/www/html;

         access_log /var/log/nginx/example.com-access.log;
         error_log  /var/log/nginx/example.com-error.log error;
         index index.html index.htm index.php;

         location / {
                      try_files $uri $uri/ /index.php$is_args$args;
         }

         location ~ \.php$ {
            include snippets/fastcgi-php.conf
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
            fastcgi_index index.php;
            include fastcgi.conf;
    }
}
EOL

sed -i 's/#server_tokens/server_tokens/g' /etc/nginx/nginx.conf

systemctl restart nginx.service

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

cat << 'EOL' > ./ubuntu_2204_server_user-setup.sh
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
EOL

print "${COLOR_GREEN}"
print "Done!"
print "${COLOR_RESET}"

print "${COLOR_YELLOW}"
echo "-------------------"
echo "Now run ubuntu_2204_server_user-setup.sh with user privileges..."
echo "-------------------"
print "${COLOR_RESET}"

chmod 755 "./ubuntu_2204_server_user-setup.sh"

