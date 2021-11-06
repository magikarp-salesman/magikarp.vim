" My custom mappings
"
if isdirectory(expand(g:vimmagikarpfolder.'/plugged'))

	" make json objects beautiful
	call toop#mapShell('jq .', '<leader>jq')
	" copy to clipboard
	call toop#mapShell('tee /dev/clip', '<leader>clip')
	
	" Leader+b for a list of buffers
	nnoremap <Leader>b :ls<CR>:b!<Space>
	command BufferClose bd

	" save buffer and close
	nnoremap <Leader>wd :w<CR>:bd<CR>

	" follow link/tag in manual pages
	nnoremap <Leader>f :call FollowPage()<CR>

	" execute line under the cursor as a command
	nnoremap <leader>el yy:@"<CR>

	" omni completion ctrl+x ctrl+o to call in insert mode
	filetype plugin on
	set omnifunc=syntaxcomplete#Complete
	" mappings to more common keys
	inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
	inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
	inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
	inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
	inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
	
	" change :x to save and close the buffer instead
	"
	if exists('g:loaded_cmdalias')
		execute "Alias x :call\\ ReplaceXToWQIfLastBufferOrElseWBD()"
	endif
endif

function! ReplaceXToWQIfLastBufferOrElseWBD()
	let s:numberOfBuffers = len(getbufinfo({'buflisted':1}))
	if (s:numberOfBuffers > 1)
		execute "silent!w"
		execute "bd"
	else
		execute "silent!wq"
	endif	
endfunction

function! FollowPage()
	call feedkeys("\<C-]>\<CR>")
endfunction

" Fix 'gx' (open link under the cursor) to work again
" https://vimtricks.com/p/open-url-under-cursor
function! OpenURLUnderCursor()
  let s:uri = expand('<cWORD>')
  let s:uri = substitute(s:uri, '?', '\\?', '')
  let s:uri = shellescape(s:uri, 1)
  if s:uri != ''
    silent exec "!open '".s:uri."'"
    :redraw!
  endif
endfunction

nnoremap gx :call OpenURLUnderCursor()<CR>

" Google search
function! SearchGoogleUnderCursor()
  let s:uri = expand('<cWORD>')
  let s:uri = substitute(s:uri, '?', '\\?', '')
  let s:uri = shellescape(s:uri, 1)
  if s:uri != ''
    silent exec "!open 'https://google.com/search?q=".s:uri."'"
    :redraw!
  endif
endfunction

nnoremap gs :call SearchGoogleUnderCursor()<CR>
