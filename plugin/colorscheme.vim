"
" Set the theme if we have it and the terminal supports it
"
if ($TERM == "xterm-256color") || (has("gui_macvim")) 
	if !empty(glob('~/.vim_magikarp/colors/badwolf.vim'))
		colorscheme badwolf
	endif
endif

" Workaround for IntelliJ embedded terminals
if ($INTELLIJ == "1")
	colorscheme Light
	hi Normal guibg=NONE ctermbg=NONE
endif

" vim : ft=vim syntax=on nowrap
