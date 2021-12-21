" Custom theme
" based on: https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/powerlineish.vim

" Normal mode                                    " fg             & bg
let s:N1 = [ '#005f00' , '#afd700' , 22  , 148 ] " darkestgreen   & brightgreen
let s:N2 = [ '#9e9e9e' , '#303030' , 247 , 236 ] " gray8          & gray2
let s:N3 = [ '#ffffff' , '#1c1b1a' , 231 , 233 ] " white          & gray4

" Insert mode                                    " fg             & bg
let s:I1 = [ '#005f5f' , '#ffffff' , 23  , 231 ] " darkestcyan    & white
let s:I2 = [ '#5fafd7' , '#0087af' , 74  , 31  ] " darkcyan       & darkblue
let s:I3 = [ '#87d7ff' , '#005f87' , 117 , 24  ] " mediumcyan     & darkestblue

" Visual mode                                    " fg             & bg
let s:V1 = [ '#080808' , '#ffaf00' , 232 , 214 ] " gray3          & brightestorange

" Replace mode                                   " fg             & bg
let s:RE = [ '#ffffff' , '#d70000' , 231 , 160 ] " white          & brightred

" Terminal mode                                  " fg             & bg
let s:TE = [ '#111111' , '#FFFF6C' , 231 , 233 ] " white          & brightyellow

let g:airline#themes#magikarpish#palette = {}

let g:airline#themes#magikarpish#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#magikarpish#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#magikarpish#palette.insert_replace = {
      \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ],
      \ 'airline_z': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#magikarpish#palette.visual = {
      \ 'airline_a': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ],
      \ 'airline_z': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ] }

let g:airline#themes#magikarpish#palette.replace = copy(airline#themes#magikarpish#palette.normal)
let g:airline#themes#magikarpish#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]
let g:airline#themes#magikarpish#palette.replace.airline_z = g:airline#themes#magikarpish#palette.replace.airline_a

let g:airline#themes#magikarpish#palette.terminal = copy(airline#themes#magikarpish#palette.normal)
let g:airline#themes#magikarpish#palette.terminal.airline_a = [ s:TE[0] , s:TE[1] , s:TE[2] , s:TE[3] , '' ]
let g:airline#themes#magikarpish#palette.terminal.airline_z = g:airline#themes#magikarpish#palette.terminal.airline_a
let g:airline#themes#magikarpish#palette.terminal.airline_term = [ s:N3[0] , s:N3[1] , s:N3[2] , s:N3[3] , '' ]

let s:IA = [ s:N2[0] , s:N3[1] , s:N2[2] , s:N3[3] , '' ]
let g:airline#themes#magikarpish#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

" vim : ft=vim syntax=on nowrap
