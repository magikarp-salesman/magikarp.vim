" Markdown related commands

function! MarkdownConvert()

	" Takes the current file
	" looks for all the markdown files in the same folder
	" bundles them together
	" converts to html
	" adds styles and scripts
	" saves it to a cache folder	
	let l:filepath = expand('%:p')
	let l:line = line(".")
	let l:ext = expand('%:e')
	let l:basedir = expand('%:p:h')
	
	if ( l:ext != "md" )
		echom "Not a markdown file (".l:filepath.")"
		return
	endif	
	
	" create folder if it doesnt exist
	let l:cachedir = l:basedir.'/.cache'
	call system('mkdir -p '.l:cachedir)

	" create links to all files to the cache folder
	call system('ls -1 '.l:basedir.' | xargs -I{} ln -sfn '.l:basedir.'/{} '.l:cachedir)

	" TODO: add mark to the current file
	" TODO: reorder files so that the file with the same name as the folder is always first
	
	" merge files
	let l:files = systemlist('ls -1 '.l:cachedir.'/*.md | sort | uniq')
	call system('cat '.join(l:files," ").' > '.l:cachedir.'/.index.md')
	
	" convert to markdown
	call system('mdtohtml '.l:cachedir.'/.index.md > '.l:cachedir.'/.index.html')

	call system('open '.l:cachedir.'/.index.html')

	" add style
	
	echom l:files

endfunction

" turning on an option makes this automatic on file save

" extra option to add youtube links and back them up automatically 

" extra option to add clips

" folder divide pages

" pages link each other

" css comes prebundled

" vim : ft=vim syntax=on nowrap
