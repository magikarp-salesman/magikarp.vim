" Basic options

setglobal noerrorbells
setglobal termguicolors

" Load MAN vim biddings

runtime ftplugin/man.vim

" Re-detect filetype when opening the file for the first time
filetype detect

" Set useragent as vim
let g:netrw_http_cmd='curl --user-agent vim -sS -o'
let g:netrw_http_put_cmd='curl --user-agent vim -sS -T'
let g:netrw_silent=1

" vim : ft=vim syntax=on nowrap
