" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'jimenezrick/vimerl'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'bling/vim-airline'

call vundle#end()

" Per filetype settings
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType coffeescript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType java setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType sql setlocal ts=3 sts=3 sw=3 expandtab
autocmd FileType tex setlocal ts=3 sts=3 sw=3 expandtab spell
autocmd FileType text setlocal ts=4 sts=4 sw=4 expandtab spell
autocmd FileType bib setlocal ts=3 sts=3 sw=3 expandtab
autocmd FileType haskell setlocal autoindent expandtab sta sw=4 sts=4 ts=2
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType erlang setlocal ts=4 sts=4 sw=4 expandtab

" Settings
filetype plugin indent on
syntax on
syntax enable
let g:indent_guides_enable_on_vim_startup = 0
set cursorline
set background=dark
set expandtab
set nospell
set foldmethod=syntax
set foldlevelstart=20
set t_Co=256
set laststatus=2
set ttimeoutlen=50
set relativenumber
set hidden
set nofsync
set noswapfile
set guioptions=Ace
autocmd ColorScheme * highlight Normal ctermbg=None
autocmd ColorScheme * highlight NonText ctermbg=None
colorscheme molokai

" airline settings
let g:airline_theme = "bubblegum"
let g:airline_powerline_fonts = 1

" YCM
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" UltiSnips
fun! GetSnipIfExist(key)
python << endpy
from UltiSnips import UltiSnips_Manager
rawsnips = UltiSnips_Manager._snips( '', 1 )
k = vim.eval('a:key')
r = k if k in  [  x.trigger for x in rawsnips ] else ''
vim.command('return "'+r+'"')
endpy
endf

fun! SnipUnderCursor()
        return GetSnipIfExist(expand('<cword>'))
endf

fun! ExpandIfSnipExists()
        let l = split(getline('.'))
        if len(l) > 0 && GetSnipIfExist(l[len(l)-1]) != ''
                return UltiSnips#ExpandSnippet()
        else
                return ''
        endif
endf

map <CR> <NOP>
inoremap <cr> <c-r>=ExpandIfSnipExists()<cr>

" Various keys
map vp :exec "w !vpaste ft=".&ft<CR>
vmap vp <ESC>:exec "'<,'>w !vpaste ft=".&ft<CR>
noremap <F12> :w<CR>:!erlc % && erl -noshell -s %:r test -s init stop<CR>
nnoremap <F5> :w <bar> silent ! ffreload<CR>
nnoremap <C-b> :w <CR> :!make run<CR>

map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-L> <C-W>l<C-W>_

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <C-p> :r !xsel <cr>
vnoremap <Space> zf

inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>  

" Limelight + Goyo
 let g:limelight_conceal_ctermfg = 'gray'
 let g:limelight_conceal_ctermfg = 240

nnoremap <C-g> :Goyo <cr>

function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd User GoyoEnter call <SID>goyo_enter()
autocmd User GoyoLeave call <SID>goyo_leave()

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
