"No need for the old compatibilty.
set nocompatible

"Google coding style
set softtabstop=2
set tabstop=2
set shiftwidth=2

set shiftround
set expandtab
autocmd FileType * set expandtab
set autoindent
"Enable syntax highlighting
syntax on

"If the search is lower case, ignore case
set ignorecase
set smartcase

"Show the command
set showcmd

"Ruler gives the position. It's off on Mac.
set ruler

"Disable visual bells.
set noerrorbells
set visualbell
set t_vb=

"Maps ';' to ':' to avoid shifting.
nore ; :
nore , ;
