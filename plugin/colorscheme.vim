" set colorscheme and color related stuff
if !empty(glob('~/.vim_magikarp/colors/devbox-dark-256.vim')) 

	" Set themes
	set t_Co=256
	colorscheme devbox-dark-256

	" Tweaks to get red errors on devbox-dark-256
	hi Error            cterm=bold              ctermfg=15          ctermbg=196
	hi ErrorMsg         cterm=bold              ctermfg=15          ctermbg=196
	hi Pmenu            cterm=NONE              ctermfg=252 	ctermbg=20
	hi PmenuSel         cterm=NONE              ctermfg=NONE	ctermbg=20

endif

" vim : ft=vim syntax=on nowrap
