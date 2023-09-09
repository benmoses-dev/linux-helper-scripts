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
	print "Composer has not been installed..."
	print "Please install php before running this script!"
	print "${COLOR_RESET}"
	sleep 2
else
	if [[ -n $(command -v composer) ]]; then
		print "${COLOR_RED}"
		print "Composer is already installed!"
		print "${COLOR_RESET}"
		sleep 2
	else
		mkdir -p "${HOME}/.local/bin"

		print "${COLOR_YELLOW}"
		print "Installing composer"
		print "${COLOR_RESET}"
		sleep 2

		EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
		php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
		ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
		if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
			echo >&2 'ERROR: Invalid installer checksum'
			rm composer-setup.php
		else
			php composer-setup.php --quiet
			RESULT="$?"
			rm composer-setup.php
			echo "Return code: ${RESULT}"
			sleep 1
		fi

		mv composer.phar "${HOME}/.local/bin/composer"

        if [[ -n $(command -v composer) || -f "${HOME}/.local/bin/composer" ]]; then
            print "${COLOR_GREEN}"
            print "Composer Installed Successfully!"
            print "${COLOR_RESET}"
            sleep 1
        else
            print "${COLOR_RED}"
            print "Something went wrong - composer not found!"
            print "${COLOR_RESET}"
            sleep 2
        fi
	fi
fi
