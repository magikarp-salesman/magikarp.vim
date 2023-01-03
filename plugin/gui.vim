if has("gui_macvim")
	let macvim_skip_colorscheme=1
	" set fu " start fullscreen
	set guifont=JetBrainsMonoNerdFontCompleteM-ExtraLight:h13,Monaco\ Nerd\ Font\ Mono:h24,Monaco:h24
	set macligatures

	" Remove scrollbars
	set guioptions-=l
	set guioptions-=L
	set guioptions-=r
	set guioptions-=R

	" Add Cmd+c to copy from visual mode to clipboard
	vnoremap <Cmd-c> "+y
endif

" vim : ft=vim syntax=on nowrap
