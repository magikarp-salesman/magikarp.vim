"true" ; set -e
"true" ; if [ "$1" == "envs" ]; then
"true" ; 	if [ -z "$VIM" ]; then
"true" ; 		echo "Sourcing :Terminal environment"
"true" ; 		tmp_file=$(mktemp)
"true" ; 		\vim -c 'set nomore' -c "redir >> ${tmp_file}" -c 'PrintTerminalEnvs' -c 'q'
"true" ; 		set -o allexport; source ${tmp_file}; set +o allexport
"true" ; 		rm "${tmp_file}"
"true" ;	fi
"true" ;	set +e && return 0
"true" ; fi 
"true" ; echo "Installing vim-plug ..."
"true" ; [ ! -f ~/.vim_magikarp/autoload/plug.vim ] && curl -fLo ~/.vim_magikarp/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"true" ; git config --global core.autocrlf input
"true" ; echo "Running PlugInstall ..."
"true" ; vim +"PlugInstall --sync"  +qall
"true" ; [ ! -f ~/.vim_magikarp/colors ] && mkdir -p ~/.vim_magikarp/colors && cp ~/.vim_magikarp/plugged/vim-colorschemes/colors/* ~/.vim_magikarp/colors
"true" ; echo "Finished installing vim-plug."
"true" ; echo ""
"true" ; echo "To source the :Terminal bash envs run:"
"true" ; echo "	source ~/.vimrc envs"
"true" ; set +e && exit 0

" We will be storing the packages and configurations on a different folder
let g:vimmagikarpfolder = expand("~/.vim_magikarp")

" Set the runtime path to something else different from ~/.vim
let &runtimepath = g:vimmagikarpfolder.",".&runtimepath 
let &packpath = g:vimmagikarpfolder.",".&packpath

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

if empty(glob(g:vimmagikarpfolder.'/autoload/plug.vim'))
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
call plug#begin(g:vimmagikarpfolder.'/plugged')

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
	
	" Distractionless environment
	Plug 'junegunn/goyo.vim'

	" Pretty icons
	Plug 'ryanoasis/vim-devicons'

	" Simple alias and basic :command substitution
	Plug 'Konfekt/vim-alias'

	" My own custom functions and configurations
	Plug 'magikarp-salesman/magikarp.vim'

call plug#end()

" vim : ft=vim syntax=on nowrap
