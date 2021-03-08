" Open terminal in new buffer
" ----
"
function Terminal()
	let options = {} " New dictionary
	let options['term_name'] = "Terminal" " all terminals have this name
	let options['term_api'] = "Terminal" " all functions have to be called TerminalXXX from inside the call/drop function
	" doesnt work - let options['term_finish'] = "close" " close as soon as the main process finishes
	let options['hidden'] = 1 " start in a hidden buffer
	let options['cwd'] = expand('%:p:h') " start in the same directory as the file we are in
	let options['term_kill'] = "hup"
	
	let s:buf = term_start(['/bin/bash','-c','source /Users/jose.placido/.vim_magikarp/plugged/magikarp.vim/dotfiles/.bashrc ; clear ; bash'], options)

	" Switch to the hidden buffer
	exec "buffer ".s:buf
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

command Terminal call Terminal()

" vim : ft=vim syntax=on nowrap
