set nocompatible              " be iMproved, required
set visualbell t_vb= " no sound 
set tabstop=4
set shiftwidth=4
set expandtab "expand tabs into spaces
set smartindent
set autowrite "save when :!
set number " show line numbers
set relativenumber " relative
set scrolloff=4 " when scrolling, keep cursor 3 lines away from screen border
set ttimeoutlen=0
" set iskeyword-=_ " set _ is word
set mouse=a
 
" ============================================================================
" Vim-plug initialization

let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" ============================================================================
" Active plugins
" You can disable or add new ones here:

call plug#begin('~/.vim/plugged')

" Plugins from github repos:
"""Plugin 'rosenfeld/conque-term'
"""" запуск интерпретатора на F5
""""nnoremap <F5> :ConqueTermSplit ipython<CR>
nnoremap <F5> :!python %<CR>
"""" а debug-mode на <F6>
"""nnoremap <F6> :exe "ConqueTermSplit ipython " . expand("%")<CR>
"""let g:ConqueTerm_StartMessages = 0
"""let g:ConqueTerm_CloseOnEnd = 1
"""nnoremap <C-J> <C-W><C-J> "tab nav
"""nnoremap <C-K> <C-W><C-K>
"""nnoremap <C-L> <C-W><C-L>
"""nnoremap <C-H> <C-W><C-H>

Plug 'python-mode/python-mode', { 'branch': 'develop' }
" autocmd BufEnter __run__,__doc__ :wincmd L "Make opened split/buff vertical
"let g:pymode_options_max_line_length = 88
"let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_options_colorcolumn = 0 "Disable redline
let g:pymode_python = 'python3'
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_lint_on_write = 0 "disable pylint check on save file
nnoremap <F4> :PymodeLint<CR>
nnoremap <leader><F4> :PymodeLintAuto<CR>
let g:pymode_virtualenv = 1 "virtualenv 
let g:pymode_breakpoint = 1 "breakpoint <leader>b
let g:pymode_run_bind = '<F6>'
let g:pymode_doc_bind = '<F1>'

"=====================================================
Plug 'davidhalter/jedi-vim'           " Jedi-vim autocomplete plugin
" set completeopt-=menuone,preview " Disable doc autoshow
set completeopt=menuone,longest " Don't apply first completion
let g:jedi#popup_select_first = 0 " Disable choose first function/method at autocomplete
let g:jedi#popup_on_dot = 0 " Disable popup after dot
let g:jedi#documentation_command = '<F1>'
"====================================================
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context" " Make it work like C-Space in jedi-vim
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabNoCompleteAfter = ['^', '\t', '\s\s']
" inoremap <silent> <expr> <CR> (pumvisible() ? "\<C-e>" : "\<CR>")
" inoremap <silent> <expr> <C-j> (pumvisible() ? "\<C-e>" : "\<CR>")
"===================================================

" Terminal Vim with 256 colors colorscheme
Plug 'fisadev/fisa-vim-colorscheme'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
let g:airline_layout = 'powerline'
let g:airline#extensions#whitespace#enabled = 0

" Tab list panel
Plug 'kien/tabman.vim'

" Autoclose bracket
Plug 'Raimondi/delimitMate'

" Better file browser
Plug 'scrooloose/nerdtree'
" toggle nerdtree display
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <leader>t :NERDTreeToggle<CR>
" open nerdtree with the current file selected
" nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '^__pycache__$', '^env$', '^.env$', '^tags$']
let NERDTreeMapJumpNextSibling = ''

Plug 'tmhedberg/SimpylFold'
" Plug 'vim-scripts/python_ifold'

" Plug 'edkolev/tmuxline.vim'

call plug#end()                       " required

" use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
	let &t_Co = 256
    colorscheme fisa
    hi Normal ctermbg=NONE ctermfg=255
    hi NonText ctermbg=NONE
    hi LineNr ctermfg=0 ctermbg=NONE
else
    colorscheme delek
endif
" colors for gvim
if has('gui_running')
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 9
    set guicursor+=a:blinkon0 " disable blinking cursor
    imap <C-v> <C-r><C-o>*
    colorscheme fisa
    hi Normal guifg=#eeeeee guibg=#202020
endif
" ============================================================================
" Install plugins the first time vim runs

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" ============================================================================
filetype on
filetype plugin on
filetype plugin indent on

" w!! save as root
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmenu
set wildmode=list:longest
nnoremap <Space> <C-d>
" nnoremap <xf0> <C-u>
" show which commands key is pressed
set showcmd
" provide hjkl movements in Insert mode via the <Alt> modifier key
" inoremap <Leader>h <Left>
" inoremap <Leader>j <Down>
" inoremap <Leader>k <Up>
inoremap <C-l> <Right>
" enable OS clipboard using, vim-gtk or vim-gtk3 package requared
set clipboard=unnamedplus
set guioptions+=a
" Not ignore case when search
set ignorecase
" Increment search and highlight all
set incsearch
set hlsearch
" K is split line
function SplitLine()
    if getline(".")[col(".")-1] == ' '
        call feedkeys("r\<CR>")
    else
        call feedkeys("F\<Space>r\<CR>")
    endif
endfunction
nnoremap S :call SplitLine()<CR>
nnoremap <F1> K
" Highlight the 80s symbol in the line
highlight ColorColumn ctermbg=52
call matchadd('ColorColumn', '\%80v', 100)
" remap , and ; in normal mode
nnoremap , ;
nnoremap ; ,
" better indent, not lose selection
vnoremap > >gv
vnoremap < <gv
" Ctrl-s to save
nnoremap <C-s> :w<CR>
" folding
set foldlevel=0
" accordion expand traversal of folds
nnoremap <silent> z] :<C-u>silent! normal! zc<CR>zjzozz
nnoremap <silent> z[ :<C-u>silent! normal! zc<CR>zkzo[zzz

" ru layout
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

nmap Ж :
" yank
nmap Н Y
nmap з p
nmap ф a
nmap щ o
nmap г u
nmap З P
