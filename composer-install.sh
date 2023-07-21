#!/usr/bin/env bash

set -e

# Colours
COLOR_YELLOW=`tput setaf 3`
COLOR_RESET=`tput sgr0`
SILENT=false

print() {
    if [[ "${SILENT}" == false ]] ; then
        echo -e "$@"
    fi
}

mkdir -p "${HOME}"/.local/bin

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

mv composer.phar "${HOME}"/.local/bin/composer
