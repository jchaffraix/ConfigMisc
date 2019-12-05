"No need for the old compatibilty.
set nocompatible

"Google coding style.
" No Tab, indent = 2 spaces.
set softtabstop=2
set tabstop=2
set shiftwidth=2
" Round the number of spaces/tabs to the previous metrics.
set shiftround
set expandtab
autocmd FileType * set expandtab

"Slack coding style.
"Using Tab.
"set noexpandtab

"Enable syntax highlighting
syntax on

"If the search is lower case, ignore case
set ignorecase
set smartcase

"Let vim add indent.
set autoindent

"Show the command
set showcmd

"Ruler gives the position. It's off on Mac.
set ruler

"Disable visual bells.
set noerrorbells
set visualbell
set t_vb=

"TODO: What is that supposed to be doing?
"Maps ';' to ':' to avoid shifting.
"nore ; :
"nore , ;
