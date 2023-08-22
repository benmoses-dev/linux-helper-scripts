set number
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab=true
set smartindent=true
set wrap=false

set updatetime=300
set scrolloff=8

" Do incremental searching.
set hlsearch=false
set incsearch

let mapleader=" "

"" -- Vim Remaps
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap J mzJ`z
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

xnoremap <leader>p "_dP
nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap Y y$
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

inoremap <C-c> <Esc>

nnoremap <leader>sr :%s/\<\>//gc

nnoremap Q gq
vnoremap Q gq

