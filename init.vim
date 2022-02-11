call plug#begin()
    Plug 'mfussenegger/nvim-jdtls'    
    "Haskell Stuff
    Plug 'neoclide/coc.vim'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'haskell/sylish-haskell'
    Plug 'neomake/neomake'      
call plug#end()

syntax on

set expandtab                     "Converts tabs to spaces
set tabstop=4                     "Tab width
set shiftwidth=4                  "Autoindent width
set linebreak                     "Line softwraps do not split words
set number relativenumber         "Sets numbering mode to hybrid
set cc=80                         "Max line length marker (Standard: 80) 
set autoindent                    "Enables autoindentation
set ignorecase                    "Searches ignore case
set noswapfile                    "Disables swap file 
set nospell
