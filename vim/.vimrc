set number

set showmatch
set smartindent
set cindent
set tabstop=4
set shiftwidth=4
syntax enable

set noswapfile
set nobackup
set noundofile

set clipboard+=unnamedplus

let &t_ti.="\e[6 q"
let &t_SI.="\e[6 q"
let &t_EI.="\e[6 q"
let &t_te.="\e[6 q"

autocmd BufNewFile *.cpp 0r /contest/cpp_library/template/auto_insert.cpp
