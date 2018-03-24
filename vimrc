" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Sep 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

  augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

colo slate
set laststatus=2
set relativenumber
set number
set exrc
set secure
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set winheight=10
set spell
set nobackup
"set colorcolumn=68
hi ColorColumn ctermbg=darkgray

augroup filetype_python
autocmd!
autocmd FileType python :setlocal tabstop=4
autocmd FileType python :setlocal softtabstop=4
autocmd FileType python :setlocal shiftwidth=4
autocmd FileType python :setlocal expandtab
autocmd FileType python :setlocal nocindent
autocmd FileType python :imap-local <c-c> '''
augroup END

augroup filetype_markdown
	autocmd!
	autocmd FileType markdown let b:surround_{char2nr('o')} = "**\r**"
augroup END

let g:pyindent_open_paren = '&sw * 2'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw * 2'

let mapleader = "-"
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <F12>     :YcmCompleter GoToDefinition<CR>
nnoremap <leader>f :YcmCompleter GoToDefinition<CR>
nnoremap <leader>c :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>r :YcmCompleter GoToReferences<CR>
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>pl :Shell pylint %<CR>

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  let isfirst = 1
  let words = []
  for word in split(a:cmdline)
    if isfirst
      let isfirst = 0  " don't change first word (shell command)
    else
      if word[0] =~ '\v[%#<]'
        let word = expand(word)
      endif
      let word = shellescape(word, 1)
    endif
    call add(words, word)
  endfor
  let expanded_cmdline = join(words)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:  ' . a:cmdline)
  call setline(2, 'Expanded to:  ' . expanded_cmdline)
  call append(line('$'), substitute(getline(2), '.', '=', 'g'))
  "silent execute '$read !'. expanded_cmdline 1
  silent execute '$read !'. expanded_cmdline
endfunction

let &path.=".,../include,~/projects/nuttx/nuttx/,/usr/include/"
" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif


" Vundle
set nocompatible	" be iMproved, required
filetype off		" required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'JamshedVesuna/vim-markdown-preview'

" All of your Plugins must be added before the following line
call vundle#end()		" required
filetype plugin indent on	" required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
"
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:vundle_default_git_proto = 'git'
let vim_markdown_preview_github=1
