" vim-plug: install and load plugins
noremap <SPACE> <Nop>
let mapleader=" "
source ~/.vim/load_plugins.vim

" ---- vanilla vim config options ----

" mouse support
set ttymouse=xterm2

set nocompatible
set hidden
set t_Co=256

filetype on
filetype plugin on
syntax enable
set incsearch
set hlsearch

set nu
set showcmd
"colorscheme molokai
colorscheme xoria256


set autoindent
" 8 is default character tab
set shiftwidth=3
set softtabstop=3
set tabstop=3
" Spaces are better than a tab character
set expandtab
set smarttab

set wildmenu
set wildmode=list:longest,full
set guifont=Droid\ Sans\ Mono\ 12

" set xterm title
set title 
let &titlestring = "vim:%{expand(\"%:p %y %L\")} ".$USER."@".hostname().":".getcwd()

" sudo save
cmap w!! %!sudo tee > /dev/null %

" perl
let perl_include_pod = 1
" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" jj is escape
inoremap jj <ESC>
" ctrl+d inserts date string when in insert mode
inoremap <c-d> <ESC>:r!date +"\%Y\%m\%d "<CR>A

" spell check: pick first 
" stole from https://castel.dev/post/lecture-notes-1/
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" 20221107 - vim-test settings
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
