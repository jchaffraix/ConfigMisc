"WebKit coding style
set softtabstop=4
set tabstop=4
set shiftwidth=4

set shiftround
set expandtab
autocmd FileType * set expandtab
set autoindent
"Enable syntax highlighting
syntax on

"If the search is lower case, ignore case
set smartcase

"Show the command
set showcmd

"Searching
set ignorecase
set smartcase

"Ruler gives the position. It's off on Mac.
set ruler

"Highlight anything wider than 80 columns
match ErrorMsg '\%>80v.\+'
