" Open terminal in new buffer
" ----
"
function Terminal(...)

	let current_dir = a:0 > 0 ? a:1 : expand('%:p:h') " start in the same directory as the file we are in

	let term_name = printf('Terminal 0x%02hX', rand(srand()) % 153) "Terminal 0x(0-99)
	let envs = TerminalGetEnvVariables()

	let options = {} " New dictionary
	let options['term_name'] = term_name " all terminals have this name
	let options['term_api'] = "Terminal" " all functions have to be called TerminalXXX from inside the call/drop function
	" doesnt work - let options['term_finish'] = "close" " close as soon as the main process finishes
	let options['hidden'] = 1 " start in a hidden buffer
	let options['cwd'] = current_dir
	let options['term_kill'] = "hup"
	let options['env'] = envs
	let options['ansi_colors'] = ['#000000', '#e00000', '#00e000', '#e0e000', '#0063ff', '#e000e0', '#00e0e0', '#e0e0e0', '#808080', '#ff4040', '#40ff40', '#ffff40', '#4040ff', '#ff40ff', '#40ffff', '#ffffff']
	
	let s:buf = term_start(['/usr/local/bin/bash'], options)

	" Switch to the hidden buffer
	exec "buffer! ".s:buf
endfunction

function TerminalOpen(bufnum, arglist)
	if len(a:arglist) == 1
		" return to normal mode
		call feedkeys("\<C-W>N")
		" arglist[0] - full filename canonical path
		call feedkeys(":badd ".a:arglist[0]."\<CR>")
		" switch to new buffer
		call feedkeys(":b! ".a:arglist[0]."\<CR>")
	endif
endfunction

function TerminalExecute(bufnum, arglist)
	if len(a:arglist) == 1
		" return to normal mode
		call feedkeys("\<C-W>N")
		" run the given comand and press enter
		echom ":".a:arglist[0]."\<CR>"
		call feedkeys(":".a:arglist[0]."\<CR>")
	endif
endfunction

function TerminalMan(bufnum, arglist)
	if len(a:arglist) == 1
		" return to normal mode
		call feedkeys("\<C-W>N")
		" open the given man page
		call feedkeys(":Man ".a:arglist[0]."\<CR>")
		" make it fullscreen
		call feedkeys(":only!\<CR>")
	endif
endfunction

function TerminalClose(bufnum, arglist)
	if len(a:arglist) == 0
		" return to normal mode
		call feedkeys("\<C-W>N")
		" close buffer
		call feedkeys(":bd! ".a:bufnum."\<CR>")	
	endif
endfunction

function TerminalNormalMode(bufnum, arglist)
	if len(a:arglist) == 0
		" return to normal mode
		call feedkeys("\<C-W>N")
	endif
endfunction

function TerminalDuplicate(bufnum, arglist)
	if len(a:arglist) == 1
		" return to normal mode
		call feedkeys("\<C-W>N")
		" open new terminal
		call feedkeys(":call Terminal(\"".a:arglist[0]."\")"."\<CR>")
	endif
endfunction

function TerminalNotification(bufnum, arglist)
	if len(a:arglist) == 2
		" popup stating the error
		call popup_create(a:arglist[1], #{
			\ line: 2,
			\ col: 1000000,
			\ pos: 'topright',
			\ minwidth: 1,
			\ time: 3000,
			\ title: ' notification ',
			\ tabpage: -1,
			\ zindex: 300,
			\ drag: 0,
			\ highlight: a:arglist[0],
			\ border: [],
			\ close: 'click',
			\ padding: [0,1,0,1],
			\ })
	endif
endfunction

function TerminalGetEnvVariables()

	let envs = {}

	let envs['BASH_SILENCE_DEPRECATION_WARNING'] = 1 " silence the deprecation bash stuff in macos
	let envs['DO_NOT_TRACK'] = 1 " please do not track using telemetry

	" commands to communicate with vim
	let envs['BASH_FUNC_vim%%'] = '() { FILEPATH=$(grealpath $1) ; echo -en "\0033]51;[\"call\",\"TerminalOpen\",[\"$FILEPATH\"]]\a" ; }'
	let envs['BASH_FUNC_new%%'] = '() { touch $1 && FILEPATH=$(grealpath $1) && echo -en "\0033]51;[\"call\",\"TerminalOpen\",[\"$FILEPATH\"]]\a" ; }'
	let envs['BASH_FUNC_exit%%'] = '() { echo -en "\0033]51;[\"call\",\"TerminalClose\",[]]\a" ; }'
	let envs['BASH_FUNC_normal%%'] = '() {  echo -en "\0033]51;[\"call\",\"TerminalNormalMode\",[]]\a" ; }'
	let envs['BASH_FUNC_error%%'] = '() { echo -en "\0033]51;[\"call\",\"TerminalNotification\",[\"ErrorMsg\",\"${1}\"]]\a" ; }'
	let envs['BASH_FUNC_warn%%'] = '() { echo -en "\0033]51;[\"call\",\"TerminalNotification\",[\"Wildmenu\",\"${1}\"]]\a" ; }'
	let envs['BASH_FUNC_:%%'] = '() { echo -en "\0033]51;[\"call\",\"TerminalExecute\",[\"${*}\"]]\a" ; }'
	let envs['BASH_FUNC_man%%'] = '() { echo -en "\0033]51;[\"call\",\"TerminalMan\",[\"${1}\"]]\a" ; }'
	let envs['BASH_FUNC_terminal%%'] = '() { DIRECTORY=$(pwd) ; echo -en "\0033]51;[\"call\",\"TerminalDuplicate\",[\"$DIRECTORY\"]]\a" ; }'
	
	let envs['BASH_FUNC___vim-wait%%'] = '() { FILEPATH=$(grealpath $1) ; echo -en "\0033]51;[\"call\",\"TerminalOpen\",[\"$FILEPATH\"]]\a" ; read -n 1 -s -r ; }'

	" change editors
	let envs['FCEDIT'] = g:vimmagikarpfolder.'/.vimwait'
	let envs['GIT_EDITOR'] = g:vimmagikarpfolder.'/.vimwait'
	let envs['EDITOR'] = 'vim'

	" set less options
	let envs['LESS'] = '--chop-long-lines -R'

	" set ls options
	let envs['CLICOLOR'] = 1

	" yes we have color..
	let envs['COLORTERM'] = 'truecolor'

	" commands to set up bash
	let envs['PROMPT_COMMAND'] = '__prompt_command'
	let init =<< trim EOF
	() {
		cat << 'HEREDOC' > ~/.vim_magikarp/.vimwait
#!/bin/bash
set -eo pipefail
vim "$1"
read -n 1 -s -r
HEREDOC
		chmod a+x ~/.vim_magikarp/.vimwait
		complete -W "$(~/.vim_magikarp/tldr 2>/dev/null --list)" tldr
		unset __init
	}
	EOF
	let envs['BASH_FUNC___init%%'] = join(init,"\n")
	let alias =<< trim EOF
	() {
		alias vi=vim
		alias v=vim
		alias vmi=vim
		alias edit=vim
		alias time_on="export VIEW_DATE=On"
		alias time_off="unset VIEW_DATE"
		alias shortpath_on="export SHORT_PATH=On"
		alias shortpath_off="unset SHORT_PATH"
		alias ls="ls -l"
		alias la="ls -la"
	}
	EOF
	let envs['BASH_FUNC___alias%%'] = join(alias,"\n")

	let prompt_command =<< trim EOF
	() {	
		ERROR_RC="${?}"
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
			H_NAME="${YELLOW}@${HOSTNAME}${RESET}"
		fi
		if [ ${ERROR_RC} -gt 0 ];then
			ERROR="${RED}"
		else
			ERROR="${GREEN}"
		fi
		if [ $ERROR_RC -gt 0 ] && [ $ERROR_RC -ne 127 ]; then
			error "code $ERROR_RC"
		fi
		if [ $SHORT_PATH ];then
			SPATH='\W'
		else
			SPATH='\w'
		fi
		export PS1="${RESET}${DATE_TIME}\u${H_NAME}${VIM_ENABLED}${GREEN}${SPATH} ${ERROR}\\$ ${RESET}"
		__alias # run alias
		LC_ALL=C type __init 2>/dev/null 1>/dev/null && __init
		set +e
		history -a # save history immediately
	}
	EOF
	let handle_unknown_command =<< trim EOF
	() {
		error "🤷 '$1' not found"
		return 127
	}
	EOF

	let tldr =<< trim EOF
	() {
		tldr_script=~/.vim_magikarp/tldr
		tldr_source=https://raw.githubusercontent.com/raylee/tldr/master/tldr
		[ -f $tldr_script ] || curl -L -o $tldr_script $tldr_source
		chmod u+x $tldr_script
		$tldr_script $1
	}
	EOF
	let envs['BASH_FUNC_tldr%%'] = join(tldr, "\n")

	let envs['BASH_FUNC___prompt_command%%'] = join(prompt_command, "\n")
	let envs['BASH_FUNC_command_not_found_handle%%'] = join(handle_unknown_command, "\n")

	return envs
endfunction

command Terminal call Terminal()

" vim : ft=vim syntax=on nowrap
