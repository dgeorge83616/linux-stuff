"{{{Auto Commands

" Automatically cd into the directory that the file is in
" nochem not good for diffsplit
" autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

augroup Source
  au!
  autocmd FileType c,cpp,python setl nu
  autocmd FileType c,cpp,python setl rnu
  autocmd FileType c,cpp,python setl expandtab
  autocmd FileType c,cpp,python setl tabstop=8
  autocmd FileType c,cpp,python setl shiftwidth=8
  autocmd FileType c,cpp,python setl softtabstop=8
  autocmd FileType c,cpp,python setl colorcolumn=80
  autocmd FileType cmake,make setl nu
  autocmd FileType cmake,make setl rnu
  autocmd FileType cmake,make setl noexpandtab
  autocmd FileType cmake,make setl tabstop=4
  autocmd FileType cmake,make setl shiftwidth=4
  autocmd FileType cmake,make setl softtabstop=4
  autocmd FileType cmake,make setl colorcolumn=80
augroup END

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
au!
autocmd BufReadPost *
\ if expand("<afile>:p:h") !=? $TEMP |
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\ let JumpCursorOnEdit_foo = line("'\"") |
\ let b:doopenfold = 1 |
\ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
\ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
\ let b:doopenfold = 2 |
\ endif |
\ exe JumpCursorOnEdit_foo |
\ endif |
\ endif
" Need to postpone using "zv" until after reading the modelines.
autocmd BufWinEnter *
\ if exists("b:doopenfold") |
\ exe "normal zv" |
\ if(b:doopenfold > 1) |
\ exe "+".1 |
\ endif |
\ unlet b:doopenfold |
\ endif
augroup END

"}}}
"" status bar that rocks

"{{{Misc Settings
set undofile

" Necesary for lots of cool vim things
set nocompatible

" This shows what you are typing as a command. I love this!
set showcmd

" Folding Stuffs
set foldmethod=marker

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*

" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab
set smarttab

" Who wants an 8 character tab? Not me!
set shiftwidth=2
set softtabstop=2

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
set spl=en spell
set nospell
endif

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse+=a

" Let me do things with the mouse inside tmux
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

" Got backspace?
set backspace=2

" This is totally awesome - remap jj to escape in insert mode.
" You'll never type jj anyway, so it's great!
inoremap jj <Esc>

nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch
" easily get rid of the highlight, until next search
noremap ./ :nohl<CR>

" Since I use linux, I want this
" nochem still not sure what's going on with clipboard
"let g:clipbrdDefaultReg = '+'

" When I close a tab, remove the buffer
set nohidden

" Set off the other paren
highlight MatchParen ctermbg=4
" }}}

"{{{Look and Feel

" Favorite Color Scheme
" nochem error: color scheme not found
"
"if has("gui_running")
"colorscheme inkpot
"" Remove Toolbar
"set guioptions-=T
""Terminus is AWESOME
"set guifont=Terminus\ 9
"else
"colorscheme metacosm
"endif

"Status line gnarliness
set laststatus=2
"set statusline=%{fugitive#statusline()}%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" }}}

"{{{ Functions

"{{{ Open URL in browser

function! Browser ()
let line = getline (".")
let line = matchstr (line, "http[^ ]*")
exec "!firefox ".line
endfunction

"}}}

"{{{Theme Rotating
let themeindex=0
function! RotateColorTheme()
let y = -1
while y == -1
let colorstring = "inkpot#ron#blue#elflord#evening#koehler#murphy#pablo#desert#torte#"
let x = match( colorstring, "#", g:themeindex )
let y = match( colorstring, "#", x + 1 )
let g:themeindex = x + 1
if y == -1
let g:themeindex = 0
else
let themestring = strpart(colorstring, x + 1, y - x - 1)
return ":colorscheme ".themestring
endif
endwhile
endfunction
" }}}

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
if g:paste_mode == 0
set paste
let g:paste_mode = 1
else
set nopaste
let g:paste_mode = 0
endif
return
endfunc
"}}}

"{{{ Todo List Mode

function! TodoListMode()
e ~/.todo.otl
Calendar
wincmd l
set foldlevel=1
tabnew ~/.notes.txt
tabfirst
" or 'norm! zMzr'
endfunction

"}}}

"}}}

"{{{ Mappings

" Open Url on this line with the browser \w
map <Leader>w :call Browser ()<CR>

" Open the Project Plugin <F2>
nnoremap <silent> <F2> :Project<CR>

" Open the Project Plugin
nnoremap <silent> <Leader>pal :Project .vimproject<CR>

" TODO Mode
nnoremap <silent> <Leader>todo :execute TodoListMode()<CR>

" Open the TagList Plugin <F3>
nnoremap <silent> <F3> :Tlist<CR>

" Next Tab
nnoremap <silent> <C-Right> :tabnext<CR>

" Previous Tab
nnoremap <silent> <C-Left> :tabprevious<CR>

" New Tab
nnoremap <silent> <C-t> :tabnew<CR>

" Rotate Color Scheme <F8>
" nnoremap <silent> <F8> :execute RotateColorTheme()<CR>

" DOS is for fools.
nnoremap <silent> <F9> :%s/$//g<CR>:%s// /g<CR>

" Paste Mode! Dang! <F8>
nnoremap <silent> <F8> :call Paste_on_off()<CR>
set pastetoggle=<F8>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

" Edit gvimrc \gv
nnoremap <silent> <Leader>gv :tabnew<CR>:e ~/.gvimrc<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Good call Benjie (r for i)
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Space will toggle folds!
nnoremap <space> za

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Testing
set completeopt=longest,menuone,preview

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Swap ; and : Convenient.
" nochem not convenient, because you are going to use 10000 vims with 10000 users
"nnoremap ; :
"nnoremap : ;

" Fix email paragraphs
nnoremap <leader>par :%s/^>$//<CR>

"ly$O#{{{ "lpjjj_%A#}}}jjzajj

"}}}

"{{{Taglist configuration
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Inc_Winwidth = 0
"}}}

let g:rct_completion_use_fri = 1
"let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_ViewRule_pdf = "kpdf"

filetype plugin indent on
syntax on

" set cursorline
set cursorline
set showmatch

"Open new split panes to right and bottom, which feels more natural than Vim’s default:

set splitbelow
set splitright


"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" version control gutter (works with git)
Plugin 'airblade/vim-gitgutter'

" Seamlessly navigate between tmux and vim panes
Plugin 'christoomey/vim-tmux-navigator'

" Python Linter
Plugin 'nvie/vim-flake8'
" Edit gpg encrypted files
Plugin 'jamessan/vim-gnupg'

" status bar that rocks
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'bling/vim-airline'

Plugin 'editorconfig/editorconfig-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'kien/rainbow_parentheses.vim'

"Plugin 'rust-lang/rust.vim'
Plugin 'lifepillar/vim-solarized8'
call vundle#end() " required

filetype plugin indent on

" call flake8 for python files
autocmd BufNewFile,BufRead *.py set ft=python
autocmd BufWritePost *.py call Flake8()
set background=dark
colorscheme solarized8_high

" syntastic configs
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set ruler
set undofile
set cursorline
set number
set ignorecase
set smartcase
set autoindent          " on new lines, match indent of previous line
set copyindent          " copy the previous indentation on autoindenting
set cindent             " smart indenting for c-like code
set cinoptions=l1,b1,g0,E-s,N-s,t0,(0,W4  " see :h cinoptions-values
set cinkeys+=0=break
set smarttab            " smart tab handling for indenting
set magic               " change the way backslashes are used in search patterns
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set nobackup            " no backup~ files.
set autoread

let g:is_posix = 1
set shortmess
set tags=./tags;/
set noerrorbells visualbell t_vb=
