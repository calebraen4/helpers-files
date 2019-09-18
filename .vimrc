"use python3 in vim
if has('python3')
endif

"set colorscheme to default
:colorscheme default

"show line numbers on the left
:set number

"highlight search strings
:set hlsearch

"All necessary things for correct tabbing (2 spaces/tab) and auto indentation
"based on syntax
:set tabstop=2     "tab width is two spaces
:set softtabstop=2 "softtabstop - backspace takes away a 'tab', i.e., 2 spaces
:set shiftwidth=2  "indenting is two spaces
:set expandtab     "expand tab characters to spaces
:set smarttab      "use sw for tab characters
:syntax on
:filetype indent on
:set autoindent    "use indent from previous line to decide indenting
:set smartindent   "like autoindent but uses some syntax rules to help
:set cindent       "stricter indent rules for C programs
:set cino=(0,ws,Ws,m1 "indent rules

" Don't indent namespace and template
function! CppNoNamespaceAndTemplateIndent()
    let l:cline_num = line('.')
    let l:cline = getline(l:cline_num)
    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
        let l:pline_num = prevnonblank(l:pline_num - 1)
        let l:pline = getline(l:pline_num)
    endwhile
    let l:retv = cindent('.')
    let l:pindent = indent(l:pline_num)
    if l:pline =~# '^\s*template\s*\s*$'
        let l:retv = l:pindent
    elseif l:pline =~# '^\s*template\s*<\s*$'
        let l:retv = l:pindent + &shiftwidth
    elseif l:pline =~# '\s*typename\s*.*,\s*$'
        let l:retv = l:pindent
    elseif l:cline =~# '^\s*>\s*$'
        let l:retv = l:pindent - &shiftwidth
    elseif l:pline =~# '\s*typename\s*.*>\s*$'
        let l:retv = l:pindent - &shiftwidth
    elseif l:pline =~# '^\s*namespace.*'
        let l:retv = 0
    endif
    return l:retv
endfunction

:set pastetoggle=<F3>

"highlights 3 columns after 80 characters, to let you know to end your line
:set tw=80
:set colorcolumn=+1,+2,+3  " highlight three columns after 'textwidth'
:highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

"highlights trailing whitespace and automatically removes it on write
:highlight ExtraWhitespace ctermbg=cyan guibg=cyan
:match ExtraWhitespace /\s\+$/
:autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
:autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:autocmd InsertLeave * match ExtraWhitespace /\s\+$/
:autocmd BufWinLeave * call clearmatches()
:autocmd InsertLeave * redraw!
:autocmd BufWritePre * :%s/\s\+$//e

"allows latex suite to recognize all .tex files for syntax highlighting
:let g:tex_flavor='latex'

"allow as many tabs to be open with -p as possible
:set tpm=30

"allows doxygen formatting to be used
":autocmd FileType c,cpp let g:load_doxygen_syntax=1

"let c++ files be viewed with correct indent rules
:au BufNewFile,BufRead *.{cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=CppNoNamespaceAndTemplateIndent()
":au BufEnter *.{.cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=CppNoNamespaceAndTemplateIndent()

"let .incl files be viewed with PHP syntax
:au BufNewFile,BufRead *.incl set ft=php

"let .cls and .sty files be viewed with Tex syntax
:au BufNewFile,BufRead *.{cls,sty} set ft=tex

"set glsl filetypes
:au BufNewFile,BufRead *.vert,*.frag set ft=glsl

"set spell check to be on for certain filetypes
:autocmd FileType html setlocal spell tw=80 fo+=t
:autocmd FileType php setlocal spell tw=80 fo+=t
:autocmd FileType tex setlocal spell tw=80 fo+=t
:autocmd FileType text setlocal spell tw=80 fo+=t

"turn off expandtab for makefiles
:autocmd FileType make setlocal noexpandtab

"allow python file to have permission upon creation
au BufWritePost * if getline(1) =~ "^#!" | silent !chmod a+x <afile>
"shortcuts
:autocmd FileType python nnoremap <buffer> <r> :exec 'w !pyton' shellescape(@%,1)<cr>
