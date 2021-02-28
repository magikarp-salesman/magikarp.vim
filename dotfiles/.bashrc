# vim: ts=2 sw=4 noexpandtab foldenable foldmethod=indent ff=unix filetype=sh nowrap :

## All that is written outside of the PROMPT> tag will not be passed to the ssh function

this_function_will_not_be_passed_onto_the_ssh_service(){
	echo "not needed there"
}

openfile(){
	echo -e "\0033]0;Telnet link to Saturn\a"
	echo -e "\0033]51;[\"drop\", \"$1\"]\a"
}

## PROMPT > 

export HISTTIMEFORMAT="%Y%m%d %T "
export HISTCONTROL="ignoreboth"

export EDITOR="vim"

export UNAME=`uname -a`
export HNAME=`hostname`
if [ -f /proc/sys/kernel/osrelease ]; then
	export VNAME=`cat /proc/sys/kernel/osrelease`
fi
if [[ $UNAME = *"Microsoft"* ]]; then
	export UNAME_WSL=1
fi
if [[ $VNAME = *"Microsoft"* ]]; then
	export UNAME_WSL=1
fi
if [[ $UNAME = *"MINGW"* ]]; then
	export UNAME_GITBASH=1
fi

__alias() {
	alias chwon=chown
	alias celar=clear
	alias lear=clear
	alias clera=clear
	alias clearr=clear
	alias ckear=clear
	alias claer=clear
	alias clar=clear
	alias cls=clear
	alias cçear=clear
	alias vmi=vim
	alias igt=git
	alias tig=git
	alias gti=git
	alias ls="ls -l --color --group-directories-first -v"
	alias dir="ls -l --color --group-directories-first -v"
	alias :q=exit
	alias :x=exit
	alias :q!=exit
	alias ll="ls -l --color --group-directories-first -v"
	alias sl="ls -l --color --group-directories-first -v"
	alias ls-="ls -l --color --group-directories-first -v"
	alias ls-l="ls -l --color --group-directories-first -v"
	alias ls-la="ls -la --color --group-directories-first -v"
	alias ls-h="ls -ld --color .* --group-directories-first -v"
	alias la="ls -la --color --group-directories-first -v"
	alias rm-rf="rm -rf"
	alias lcoate="locate"
	alias loacte="locate"
	alias history_="history | cut -c 8- | sort -u"
	alias mc="mc --skin=modarin256 -u -c"
	alias ..="cd_ .."
	alias mk=mkdir
	alias du="du -h"
	alias df="df -h"
	alias copy=cp
	alias move=mv
	alias remove=rm
	alias bsah=bash
	alias diff="diff --color=always -y"
	alias lesscolor="less -R"
	alias ssh-listkeys="ssh-add -L"
}

time_on(){ export VIEW_DATE=On ; }

time_off(){ unset VIEW_DATE ; }

path_on(){ unset SHORT_PATH ; }

path_off(){ export SHORT_PATH=On ; }

vim_on(){ 
	set -o vi
	vim=`which vim`
	export VI_MODE=On
	export EDITOR=${vim}
	export VISUAL=${vim}
}

vim_off(){ 
	set -o emacs ;
	unset VI_MODE
}

cd_(){
	cd "$*" && DIRECTORIES+=(`pwd`) && ls --color=auto -la
}

beep(){
	echo -ne '\007'
}

export -f __alias
export -f cd_
export -f beep
export -f vim_on
export -f vim_off
export -f time_on
export -f time_off
export -f path_on
export -f path_off
export PROMPT_COMMAND=__prompt_command

__prompt_command() {
	ERROR_RC="$?"
	set -e
	RED='\[\033[31m\]'
	GREEN='\[\033[32m\]'
	YELLOW='\[\033[33m\]'
	RESET='\[\033[0m\]'
	HIDDEN='\[\033[38;5;239m\]'
	DIM='\[\033[2m\]'
	DATE_TIME=""
	if [ $VIEW_DATE ];then
		date_var=`date -u +%Y%m%d-%H:%M:%S%Z`
		DATE_TIME="${DIM}${date_var}${RESET} "
	fi
	if [ $VI_MODE ];then
		VIM_ENABLED="${RED}${RESET}"
	else
		VIM_ENABLED=":"
	fi
	if [ $UNAME_WSL ] || [ $UNAME_GITBASH ];then
		H_NAME=''
	else
		H_NAME="${YELLOW}@${HNAME}${RESET}"
	fi
		if [ ${ERROR_RC} -gt 0 ];then
				ERROR="${RED}"
		beep
		else
				ERROR="${GREEN}"
		fi
	if [ $SHORT_PATH ];then
		SPATH='\W'
	else
		SPATH='\w'
	fi
		export PS1="${RESET}${DATE_TIME}\u${H_NAME}${VIM_ENABLED}${GREEN}${SPATH} ${ERROR}\\$ ${RESET}"
	__alias # run alias
	set +e
	history -a # save history immediately
	if [ $TMUX_PANE ]; then
		tmux set -qg status-right "$(pwd)"
	fi
}

export -f __prompt_command
export DIRECTORIES=('/root')
DIRECTORIES+=(`readlink -f ~`)

function dir_pick(){
	DIRECTORIES=($(printf "%s\n" "${DIRECTORIES[@]}" | uniq))
	select opt in "${DIRECTORIES[@]}"
	do
		if [ ! -z "$opt" ]; then
			echo "cd ${opt}"
			cd "${opt}"
		fi
		break
	done
}

function calc(){
	echo "scale=2;$*" | bc -l
}

function untar(){
	tar -zxvf ${*}
}

function record_() {
	if [ -z "$1" ]; then
		filename='new_record.script'
	else
		filename="$1.script"
	fi
	timing_file=`mktemp`
	script_file=`mktemp`
	fast_timing_file=`mktemp`
	script -t $script_file 2> $timing_file
	# FAST RECORD
	while read line; do
		var1=${line%\ *}
		var2=${line#*\ }
		max=10
		numeric=${var1%\.*}
		numeric=$(( numeric ))
		if [ $numeric -gt $max ]; then
			var1="10"
		fi
		printf "%s %s\n" "$var1" "$var2" >> $fast_timing_file
	done < $timing_file 
	timing_64=`cat $timing_file | gzip -cn9 | base64 -w 0`
	script_64=`cat $script_file | gzip -cn9 | base64 -w 0`
	fast_timing_64=`cat $fast_timing_file | gzip -cn9 | base64 -w 0`
	template=$(cat <<'END_OF_DOCUMENT'
#!/bin/bash
set -e
function command_exists(){
	command -v $1 1>/dev/null || ( echo "$1 not found" ; exit 1 )
}
command_exists mktemp
command_exists base64
command_exists gzip
command_exists script
command_exists scriptreplay
timing_file=`mktemp`
script_file=`mktemp`
fast_timing_file=`mktemp`
YELLOW_BG='\033[43m'
BLACK='\033[30m'
RESET='\033[0m'
echo '%s' | base64 -d --ignore-garbage | gzip -cd > $timing_file
echo '%s' | base64 -d --ignore-garbage | gzip -cd > $script_file
echo '%s' | base64 -d --ignore-garbage | gzip -cd > $fast_timing_file
scriptreplay $fast_timing_file $script_file $@
echo -e "${YELLOW_BG}${BLACK} end of script ${RESET}"
rm $timing_file $script_file $fast_timing_file
exit 0

END_OF_DOCUMENT
	)
	printf "$template" $timing_64 $script_64 $fast_timing_64 > $filename
	rm $timing_file $script_file $fast_timing_file
}

function tail_(){	
	RED=$(printf '\033[31m')
	GREEN=$(printf '\033[32m')
	YELLOW=$(printf '\033[33m')
	WHITE=$(printf '\033[0m')
	BLUE=$(printf '\033[34m')
	RESET='\[\033[0m\]'
	lines=`tput lines`
	tail -n ${lines} -F $* 2>&1 | \
		sed -u -e "s/ERROR/${RED}&${WHITE}/g" | \
		sed -u -e "s/WARN/${YELLOW}&${WHITE}/g" | \
		sed -u -e "s/INFO/${BLUE}&${WHITE}/g" | \
		sed -u -e "s/success/${GREEN}&${WHITE}/g" | \
		sed -u -e "s/started/${GREEN}&${WHITE}/g" | \
		sed -u -e "s/Exception/${RED}&${WHITE}/g" | \
		sed -u -e "s/==>/${YELLOW}&${WHITE}/g" | \
		sed -u -e "s/<==/${YELLOW}&${WHITE}/g" | \
		sed -u -e "s/No\ such\ file\ or\ directory/${YELLOW}&${WHITE}/g" 
}

function grep_(){
	which pgrep 2>&1 >/dev/null
	if [ "$?" -eq 0 ]; then
		pgrep -f -l -a $@
	else
		ps aux | grep $@ | grep -v grep
	fi
}

export -f dir_pick
export -f calc
export -f tail_
export -f untar
export -f record_
export -f grep_

if [ "$HAS_SCREEN" -eq 0 ] && [ ! $TMUX ] && [ $USE_SCREEN ]; then
	echo "Screen session started on host $USER:$HOSTNAME."
	screen -d -RR remote_session
	exit
fi

## PROMPT < 

file=`cat $BASH_SOURCE | sed -n '/## PROMPT >/{:a;n;/## PROMPT </q;p;ba}'`
prompt_base64=`echo -n "$file" | base64 -w 0`
remote_prompt=". <(echo -n \"$prompt_base64\" | base64 -d) ; bash"


ssh_() {
	RED=$(printf '\033[31m')
	GREEN=$(printf '\033[32m')
	YELLOW=$(printf '\033[33m')
	WHITE=$(printf '\033[0m')
	arguments=${*}
	extra_prompt=""
	if [ $TMUX_PANE ]; then
		printf "\033k${arguments}\033\\"
	fi
	ssh -o ServerAliveInterval=6 -o ServerAliveCountMax=10 -o PreferredAuthentications=password,publickey -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q -t $arguments "$remote_prompt $extra_prompt" 
	error_code=$?
	if [ ! -z "$sshpass_cmd" ] && [ $error_code -eq 5 ]; then
		echo -e "\n${RED}ssh_ ${WHITE}wrong password." >&2
	elif [ $error_code -ne 0 ]; then
		echo -e "\n${RED}ssh_ ${WHITE}exit error code: $error_code" >&2
	fi
	tmux -q set automatic-rename
	return $error_code
} 

copy_() {
	filename="$1"
	base64_file=`cat $1 | gzip -9 - | base64 -w 0`
	echo "set -e ; touch $1 ; echo \"$base64_file\" | base64 -d | gzip -cd > $1 ; clear ; ls -la ; set +e" > /dev/clipboard
}

export remote_prompt
export -f ssh_

export MAVEN_OPTS='-Djansi.passthrough=true -Dstyle.info=blue -Dstyle.error=red -Dstyle.warning=yellow -Dstyle.success=green -Dstyle.debug=cyan'

if [ $UNAME_GITBASH ];then
	export JAVA_HOME='C:\Program Files\Java\jdk1.8.0_181'
	export PYTHON_HOME='C:\Python27'
	export JYTHON_HOME='C:\Jython'
	export MAVEN_HOME='C:\Maven'
	alias nvim="winpty nvim"
	alias python="winpty python"
	alias npm="winpty npm.cmd"
	alias npx="winpty npx.cmd"
	alias docker="winpty docker"
fi

if [ $UNAME_WSL ];then
	alias docker="docker --host=tcp://127.0.0.1:2375"
fi

if [ $TMUX_PANE ] && [ -f ~/vim-tmux-shell ] && [ ! $RUNNING_INSIDE_VIM ]; then
	alias vim="vim -c 'set shell=~/vim-tmux-shell'"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
