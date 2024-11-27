
# Text editing
export EDITOR='nvim'
alias edit='${=EDITOR} $@'
alias sedit='sudo -E edit'
alias e='edit'
alias se='sedit'


# Quick file edits
alias zshrc='${=EDITOR} ~/.zshrc'
alias arc='${=EDITOR} ~/.oh-my-zsh/custom/profile.zsh'


# Change default commands
alias rm='rm -iv'
alias cp='cp -v'
alias mv='mv -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias tree='tree -CAF --dirsfirst'
#alias ps='ps auxf'


# Shorthand commands
alias jc='journalctl'
alias sc='systemctl'
alias scf='systemctl list-units --failed'
alias rhit='systemctl reboot'
alias shit='systemctl poweroff'
alias j='just'
alias treed='tree -d'


# Logging / printing functions
export LESS='-RKF'
export MANPAGER="sh -c 'col -bx | bat -pl man'"
export MANROFFOPT="-c"
alias bat='bat -ppl log'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Follows the file's output, showing a live log
alias lgf="tail -f -n100 $1 | bat"
# Follow a systemd unit's output
function jlgf() {
	journalctl -u $@ -f --lines=100 --no-pager | bat
}

# Opens the file, goes to the bottom, interactive so you can navigate it
alias lg='bat --paging=auto --pager="less +G" -pl log $@'
# Open a systemd unit's log
function jlg() {
	journalctl --no-pager -u $@ | bat --pager='less +G'
}


# Show disk space
alias duff='duf -only-mp "/mnt*"'
alias dff='df --output=target,source,fstype,size,used,avail,pcent -h | (sed -u 1q; sort -k 1,1)'
alias dfa='du -h -d1 | sort -hr'


nic() {
	local dirs=(
		"~/github/nixdots"
		"~/code/nixdots"
		"~/nixdots"
		"/etc/nixos/nixdots"
	)

	for dir in "${dirs[@]}"; do
		# Check if directory exists and we have read+write permissions
		if [[ -d "$dir" ]] && [[ -r "$dir" ]] && [[ -w "$dir" ]]; then
			cd "$dir" && $EDITOR "$dir"
		elif [[ -d "$dir" ]]
			sudo -E $EDITOR "$dir"
		fi
	done
}

immich() {
	case $1 in
		up) sudo systemctl start docker-immich-{ml,server,microservices,postgres,redis} ;;
	down) sudo systemctl stop docker-immich-{ml,server,microservices,postgres,redis} ;;
		 *) echo "type down or up" ;;
	esac
}

alias lsgpu='sudo intel_gpu_top'

# Copy font from yad list
alias fonts='yad --font | wl-copy'

# Quick edit shell configs
alias vic='edit ~/.config/nvim/lua/user'
alias zrc='edit ~/.zshrc'
alias brc='edit ~/.bashrc'
alias arc='edit ~/.bash_aliases'
alias rbrc='sudoedit /etc/bash.bashrc'

# Duplicate the terminal
alias dup='${=TERMINAL} --working-directory "$(pwd)" &'

# Allows aliases to be used after sudo
alias sudo='sudo '
alias adm='sudo -s'

# Remove a directory and all files
alias rmd='rm  --recursive --force --verbose '
# Neovim's swap directory which annoys me sometimes
alias vds='rm -f ~/.local/state/nvim/swap/*'

# alias ls="ls -AFh --color=always" # add colors and file type extensions
# alias lx="ls -lXBh" # sort by extension
# alias lk="ls -lSrh" # sort by size
# alias lc="ls -lcrh" # sort by change time
# alias lu="ls -lurh" # sort by access time
# alias lr="ls -lRh" # recursive ls
# alias lt="ls -ltrh" # sort by date
# alias lw="ls -xAh" # wide listing format
# alias ll="ls -Fls" # long listing format
# alias labc="ls -lAp" #alphabetical sort
# alias ldir="ls -l | egrep '^d'" # directories only
# alias lf="ls -l | egrep -v '^d'" # files only
alias cd..='cd ..'
alias cd...='cd ...'
alias cd....='cd ....'
alias lf="yazi"
alias ii='thunar'

# Top 10 processes by CPU usage
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
# Show open ports
alias openports='netstat -nape --inet'

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"


# Find nix package location and copy
np (){
  file=$( eza --color=never -D /nix/store | fzf --preview='tree /nix/store/{}')
  echo "/nix/store/$file"
  echo "/nix/store/$file" | wl-copy
}
npy (){
  file=$( eza --color=never -D /nix/store | fzf --preview='tree /nix/store/{}')
  echo "/nix/store/$file" | wl-copy
  yazi "/nix/store/$file"
}

# Searches for text in all files in the current folder
ftext () {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
	| awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg () {
	if [ -d "$2" ];then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg () {
	if [ -d "$2" ];then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Create and go to the directory
mkdg () {
	mkdir -p "$1"
	cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up () {
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

#Automatically do an ls after each cd
# cd () {
# 	if [ -n "$1" ]; then
# 		builtin cd "$@" && ls
# 	else
# 		builtin cd ~ && ls
# 	fi
# }

# Show the current distribution
distribution () {
	local dtype
	# Assume unknown
	dtype="unknown"
	
	# First test against Fedora / RHEL / CentOS / generic Redhat derivative
	if [ -r /etc/rc.d/init.d/functions ]; then
		source /etc/rc.d/init.d/functions
		[ zz`type -t passed 2>/dev/null` == "zzfunction" ] && dtype="redhat"
	
	# Then test against SUSE (must be after Redhat,
	# I've seen rc.status on Ubuntu I think? TODO: Recheck that)
	elif [ -r /etc/rc.status ]; then
		source /etc/rc.status
		[ zz`type -t rc_reset 2>/dev/null` == "zzfunction" ] && dtype="suse"
	
	# Then test against Debian, Ubuntu and friends
	elif [ -r /lib/lsb/init-functions ]; then
		source /lib/lsb/init-functions
		[ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && dtype="debian"
	
	# Then test against Gentoo
	elif [ -r /etc/init.d/functions.sh ]; then
		source /etc/init.d/functions.sh
		[ zz`type -t ebegin 2>/dev/null` == "zzfunction" ] && dtype="gentoo"
	
	# For Mandriva we currently just test if /etc/mandriva-release exists
	# and isn't empty (TODO: Find a better way :)
	elif [ -s /etc/mandriva-release ]; then
		dtype="mandriva"

	# For Slackware we currently just test if /etc/slackware-version exists
	elif [ -s /etc/slackware-version ]; then
		dtype="slackware"

	fi
	echo $dtype
}

# Show the current version of the operating system
ver () {
	local dtype
	dtype=$(distribution)

	if [ $dtype == "redhat" ]; then
		if [ -s /etc/redhat-release ]; then
			cat /etc/redhat-release && uname -a
		else
			cat /etc/issue && uname -a
		fi
	elif [ $dtype == "suse" ]; then
		cat /etc/SuSE-release
	elif [ $dtype == "debian" ]; then
		lsb_release -a
		# sudo cat /etc/issue && sudo cat /etc/issue.net && sudo cat /etc/lsb_release && sudo cat /etc/os-release # Linux Mint option 2
	elif [ $dtype == "gentoo" ]; then
		cat /etc/gentoo-release
	elif [ $dtype == "mandriva" ]; then
		cat /etc/mandriva-release
	elif [ $dtype == "slackware" ]; then
		cat /etc/slackware-version
	else
		if [ -s /etc/issue ]; then
			cat /etc/issue
		else
			echo "Error: Unknown distribution"
			exit 1
		fi
	fi
}

# IP address lookup
getip () {
	# External IP Lookup
	echo -n "External IP: " ; curl http://ifconfig.me/ip
}
