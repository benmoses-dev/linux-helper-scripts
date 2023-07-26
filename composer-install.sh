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

if [[ -z $(command -v php) ]]; then
	print "${COLOR_RED}"
	print "Composer not installed..."
	print "Please install php before running this script!"
	print "${COLOR_RESET}"
else
    if [[ -n $(command -v composer) ]]; then
        print "${COLOR_RED}"
        print "Composer already installed!"
        print "${COLOR_RESET}"
    else
        mkdir -p "${HOME}/.local/bin"

        print "${COLOR_YELLOW}"
        print "Installing composer"
        print "${COLOR_RESET}"

        EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
        if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
            echo >&2 'ERROR: Invalid installer checksum'
            rm composer-setup.php
        else
            php composer-setup.php --quiet
            RESULT=$?
            rm composer-setup.php
            echo $RESULT
        fi

        mv composer.phar "${HOME}/.local/bin/composer"

        print "${COLOR_GREEN}"
        print "Composer Installed Successfully!"
        print "${COLOR_RESET}"
    fi
fi
