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

error() {
    print "${COLOR_RED}"
    print "${1}"
    print "${COLOR_RESET}"
}

info() {
    print "${COLOR_YELLOW}"
    print "${1}"
    print "${COLOR_RESET}"
}

warning() {
    print "${COLOR_BLUE}"
    print "${1}"
    print "${COLOR_RESET}"
}

success() {
    print "${COLOR_GREEN}"
    print "${1}"
    print "${COLOR_RESET}"
}

if [[ -z $(command -v php) ]]; then
	error "Composer has not been installed..."
	error "Please install php before running this script!"
	sleep 2
else
	if [[ -n $(command -v composer) ]]; then
		warning "Composer is already installed!"
		sleep 2
	else
		mkdir -p "${HOME}/.local/bin"

		info "Installing composer"
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
            success "Composer Installed Successfully!"
            sleep 1
        else
            error "Something went wrong - composer not found!"
            sleep 2
        fi
	fi
fi
