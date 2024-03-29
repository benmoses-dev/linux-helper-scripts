# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# aliases for multiple directory listing commands
alias la='ls -Alh' # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh' # sort by extension
alias lk='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias lr='ls -lRh' # recursive ls
alias lt='ls -ltrh' # sort by date
alias lm='ls -alh |more' # pipe through 'more'
alias lw='ls -xAh' # wide listing format
alias ll='ls -AlFhp --group-directories-first' # long listing format
alias labc='ls -lap' #alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only
alias l='ls -CF'
alias le='exa -laFghm --group-directories-first --icons'

# add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# open file manager in specified directory
fm-open () {
	nohup nautilus -w "$1" > /dev/null 2>&1 &
}

# change to windows home dir in wsl
chwindows() {
    cd /mnt/c/Users || exit
}

alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias multitail='multitail --no-repeat -c'
alias vi='nvim'
alias vim='nvim'
alias bat='batcat'
alias fd='fdfind'
alias _copy='xclip -selection clipboard -i'
alias _paste='xclip -selection clipboard -o'

# cd into the old directory
alias bd='cd "$OLDPWD"'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# to see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# aliases to show disk space and space used in a folder
alias folders='du -h --max-depth=1'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# fuzzy-find under the current directory and open the file or directory in neovim
# useful for quickly finding and editing stand-alone files such as configs
alias fvi='fzf --print0 | xargs -0 -o nvim'

# alias for tmux sessionizer
# find all directories as configured in ~/.local/bin/tmux-sessionizer
# opens the selected directory in a new tmux session and attaches
# useful for quickly finding projects, which can then be opened with vi .
alias ts='tmux-sessionizer'

# aliases for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in "$@"; do
		if [ -f "$archive" ] ; then
			case "$archive" in
				*.tar.bz2)   tar xvjf "$archive"    ;;
				*.tar.gz)    tar xvzf "$archive"    ;;
				*.bz2)       bunzip2 "$archive"     ;;
				*.rar)       rar x "$archive"       ;;
				*.gz)        gunzip "$archive"      ;;
				*.tar)       tar xvf "$archive"     ;;
				*.tbz2)      tar xvjf "$archive"    ;;
				*.tgz)       tar xvzf "$archive"    ;;
				*.zip)       unzip "$archive"       ;;
				*.Z)         uncompress "$archive"  ;;
				*.7z)        7z x "$archive"        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# searches for text in all files in the current folder
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r

    # or just use ripgrep, if it's installed
}

function artisan() {
    php artisan "$@"
}
alias art=artisan
alias xoff='sudo phpdismod -s cli xdebug'
alias xon='sudo phpenmod -s cli xdebug'
alias php73='sudo update-alternatives --set php /usr/bin/php7.3'
alias php74='sudo update-alternatives --set php /usr/bin/php7.4'
alias php80='sudo update-alternatives --set php /usr/bin/php8.0'
alias php81='sudo update-alternatives --set php /usr/bin/php8.1'
alias php82='sudo update-alternatives --set php /usr/bin/php8.2'
