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

if [[ "$EUID" -ne 0 ]]; then
	print "${COLOR_RED}"
	print "Please run this script as root!"
	print "${COLOR_RESET}"
	exit 0
fi

print "${COLOR_YELLOW}"
print "Updating System..."
print "${COLOR_RESET}"
apt update && apt upgrade -y
snap refresh
apt autoremove -y

print "${COLOR_YELLOW}"
print "Installing Software..."
print "${COLOR_RESET}"

apt install inetutils-traceroute net-tools curl gnupg git build-essential openjdk-17-jdk tmux python3-dev python3-pip python3-venv -y
apt install vim shellcheck ripgrep fd-find xclip trash-cli multitail tree jq rsync fzf libfuse2 -y
apt install neofetch htop cmatrix lolcat sl -y
apt install apt-transport-https ca-certificates wget -y
apt install mariadb-server nginx -y
apt install php php-fpm php-cli php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath php-xdebug -y

systemctl enable --now php8.1-fpm.service
systemctl enable --now nginx.service

cat <<'EOL' >/etc/nginx/sites-available/default
server {
    listen       80;
    server_name  example.com;
    root         /var/www/html;

    access_log /var/log/nginx/example.com-access.log;
    error_log  /var/log/nginx/example.com-error.log error;
    index index.html index.htm index.php;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOL

sed -i 's/#server_tokens/server_tokens/g' /etc/nginx/nginx.conf

systemctl restart nginx.service

# install docker
wget -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/docker-install.sh | bash

print "${COLOR_GREEN}"
print "Software Installed Successfully!"
print "${COLOR_RESET}"
