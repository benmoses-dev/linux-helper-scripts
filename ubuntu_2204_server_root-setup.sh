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
apt install mariadb-server nginx -y
apt install php php-fpm php-cli php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath -y

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

print "${COLOR_GREEN}"
print "Done!"
print "${COLOR_RESET}"

