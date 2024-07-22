syntax on
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
colorscheme default
set mouse-=a

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

set number

autocmd FileType make setlocal noexpandtab
