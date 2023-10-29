" install vim-plug if not installed (20190822)
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')


" Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/xoria256.vim'

" 20231029 - disabled. slow. adds +50ms to load time
"Plug 'easymotion/vim-easymotion' " space,space,f_ (leader,leader,find, letter)

" --- tmux integration
" vim-screen
Plug 'ervandew/screen' 
" use tmux in another terminal, dont close, strip whitespaces
let g:ScreenImpl = 'Tmux'
let g:ScreenShellExternal = 1
let g:ScreenShellQuitOnVimExit = 0
let g:ScreenShellTerminal = 'xterm'
let g:ScreenIPython3 = 1
" keybindings like nvim-R plugin 
nmap <leader>rf :ScreenShell<CR>
nmap <leader>pf :IPython<CR>
nmap <leader>rd V:ScreenSend<CR>Vj
nmap <leader>rb {V}:ScreenSend<CR>Vj
vmap <leader>rs :ScreenSend<CR>

Plug 'tpope/vim-surround'
" e.g. change surrounding quotes cs"'
Plug 'tpope/vim-repeat'
" and allow this action to repeate with .


"  See Also
"   Plug 'christoomey/vim-tmux-runner'
"   let g:VtrStripLeadingWhitespace = 0
"   let g:VtrClearEmptyLines = 0
"   let g:VtrAppendNewline = 1
"   noremap <silent> <C-c> :call RunTmuxPythonLine()<CR>
"  OR
"   Plug 'tpope/vim-tbone'
"  OR
"   Plug 'benmills/vimux'
"  OR maybe
"   Plug 'julienr/vim-cellmode'
"   let g:cellmode_screen_sessionname='ipython'

" markdown editor
" 20231029 - removed to improve startup time
"Plug 'JamshedVesuna/vim-markdown-preview'
"let vim_markdown_preview_github=1

" ---- snippets -----
" Snippets engine -- need pyton, vim-nox for debian
Plug 'SirVer/ultisnips'
" Snippets templates
Plug 'honza/vim-snippets'
" config 
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" 20171023 - https://statico.github.io/vim3.html: 'Vim after 15 years'
"fzf fuzzy finder
Plug '~/src/world/utils/fzf/' " need to get fzf in vim
Plug 'vim-scripts/ack.vim'    " ag search
Plug 'junegunn/fzf.vim' " define :Buffers :Files :Ag, fzf-complete-*
nmap <silent> <leader>a :Ag<CR>
nmap <silent> <leader>b :Buffers<CR>
nmap <silent> <leader>t :Files<CR>
" https://github.com/iggredible/Learn-Vim/blob/master/ch03_searching_files.md
nnoremap <silent> <leader><C-f> :Files<CR>

Plug 'tpope/vim-fugitive'     " :Gcommit, :Gblame
Plug 'airblade/vim-gitgutter' " changes on side

" 20231029 - disabled b/c slow and not used
"Plug 'tpope/vim-unimpaired' "][ + q,n,os
Plug 'vim-utils/vim-husk'


Plug 'w0rp/ale' " lint
let g:ale_fixers = {'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8']}
let g:ale_r_lintr_options =  "with_defaults(infix_spaces_linter=NULL, absolute_paths_linter=NULL)"

" 20231029 - removed to impove startup performance
"Plug 'kana/vim-fakeclip' " work around for vim complile w/-clipbord
"let g:fakeclip_terminal_multiplexer_type="tmux"


" -- replaced with fzf
" Plug 'wincent/Command-T' " leader j,t,b
" nmap <silent> <leader>s <Plug>(CommandTSearch)
" nmap <silent> <leader>c <Plug>(CommandTHistory)


Plug 'jalvesaq/Nvim-R'
let R_assign = 3 " ' _ ' => -> (default is any '_' becomes '->' )
" completion while typing
"  Plug 'roxma/vim-hug-neovim-rpc'
"  Plug 'roxma/nvim-completion-manager'
"  " OR ??
"  Plug 'prabirshrestha/asyncomplete.vim'
"
"  " Either way, for R, need
"  Plug 'gaalcaras/ncm-R'

" added 20220807 (pkg last updated Apr 2020)
" removed 20231029 - 600ms to load!
"    vim --startuptime /tmp/vim-time.log
"    sed 's/ \+/\t/g' /tmp/vim-time.log|sort -k2,2nr
" Plug 'jakykong/vim-zim'
" let g:zim_notebooks_dir="$HOME/notes/WorkWiki"
" let g:zim_dev_keys=1

" 20221107 - testing (initially for bats)
Plug 'vim-test/vim-test'
let g:test#shell#bats#file_pattern = '\v\.(bats|bash|sh)'
let g:test#shell#bats#patterns = {
        \ 'test': [
        \ '\v^\s*\@test %("|'')(.*)%("|'')',
        \ '\v^(\w+)\W*#\@test'
        \ ],
        \ 'namespace': []
        \ }

" 20221107 - quick view on registars: normal ^R, insert quote @
Plug 'junegunn/vim-peekaboo'

" 20221213
Plug 'vim-test/vim-test'
nmap <silent> <leader>t :TestNearest<CR>

" 20230502 
Plug 'wakatime/vim-wakatime'

call plug#end()
