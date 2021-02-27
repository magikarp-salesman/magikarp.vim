"true" ; echo "Installing vim-plug ..."
"true" ; set -e
"true" ; [ ! -f ~/.vim_magikarp/autoload/plug.vim ] && curl -fLo ~/.vim_magikarp/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"true" ; git config --global core.autocrlf input
"true" ; echo "Running PlugInstall ..."
"true" ; vim +"PlugInstall --sync"  +qall
"true" ; [ ! -f ~/.vim_magikarp/colors ] && mkdir -p ~/.vim_magikarp/colors && cp ~/.vim_magikarp/plugged/vim-colorschemes/colors/* ~/.vim_magikarp/colors
"true" ; echo "Finished installing vim-plug."
"true" ; set +e && exit 0

" Set the runtime path to something else different from ~/.vim
let &runtimepath = "~/.vim_magikarp,".&runtimepath 
let &packpath = "~/.vim_magikarp,".&packpath

" Base options
set nocompatible              " be iMproved, required
set modeline		      " read 5 first/last lines looking for modelines
set syntax=on                 " highlight syntax
set filetype=on
set laststatus=2

" Search down into subfolders
set path+=**
set wildignore+=/usr/include/**
set wildignore+=**/node_modules/**
set wildignore+=**/.cache/**

" The default for 'backspace' is very confusing to new users, so change it to a
" more sensible value.  Add "set backspace&" to your ~/.vimrc to reset it.
set backspace+=indent,eol,start

" Display all matching files when tabbing
set wildmenu

" Do not save backup files in the same directory as the file
set backupdir=.backup/,~/.backup/,/tmp//,/var/tmp//
set directory=.swp/,~/.swp/,/tmp//,/var/tmp//
set undodir=.undo/,~/.undo/,/tmp//,/var/tmp//

if empty(glob('~/.vim_magikarp/autoload/plug.vim'))
	echom "vim-plug not installed! run this command to install it automatically:"	
	echom "    bash .vimrc"
	echom " "
	finish " exit
endif

" Settings	

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim_magikarp/plugged')

	" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

	Plug 'flazz/vim-colorschemes'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

	" Text operations
	Plug 'jeanCarloMachado/vim-toop'

	" Special targets
	Plug 'wellle/targets.vim'

	" My own custom functions and configurations
	Plug 'magikarp-salesman/magikarp.vim'

" Initialize plugin system
call plug#end()

if isdirectory(expand("~/.vim_magikarp/plugged"))

	" make json objects beautiful
	call toop#mapShell('jq .', '<leader>jq')
	" make copy to clipboard
	call toop#mapShell('tee /dev/clip', '<leader>clip')
	

	" omni completion ctrl+x ctrl+o to call in insert mode
	filetype plugin on
	set omnifunc=syntaxcomplete#Complete
	" mappings to more common keys
	inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
	inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
	inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
	inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
	inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
	
endif

" vim : ft=vim syntax=on nowrap
