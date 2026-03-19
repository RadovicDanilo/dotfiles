let mapleader = ","
set clipboard=unnamedplus
set number relativenumber
set ignorecase smartcase
set hlsearch incsearch
set scrolloff=10
set timeoutlen=500
set cursorline      
set showmatch       

" Tab & Indent
set expandtab smarttab
set shiftwidth=4 tabstop=4
set autoindent smartindent

" --- The 'All' Macros ---
nnoremap <leader>a :%y+<CR>
nnoremap <leader>p ggVGp

" --- Navigation (Centered) ---
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz

" --- Better Home/End ---
noremap H ^
noremap L $

" --- Line Movement (Alt+j / Alt+k) ---
nnoremap <M-j> :m+<CR>==
nnoremap <M-k> :m-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>
nnoremap <space> :noh<CR>

nnoremap <leader>w :w!<CR>

autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe 
autocmd BufWritePre * silent! %s/\s\+$//e