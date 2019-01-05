set nocompatible              " be iMproved, required
filetype off                  " required 
set visualbell t_vb= " отключаем пищалку 
"set novisualbell " и мигание
"set belloff=all
set smarttab " настройка на Tab
set tabstop=4
set shiftwidth=4
set expandtab "expand tabs into spaces
set smartindent
set autowrite "save when :!
set number " show line numbers
set relativenumber " relative
set scrolloff=4 " when scrolling, keep cursor 3 lines away from screen border
set timeoutlen=1000 ttimeoutlen=0 " remove delay when ESC
" set iskeyword-=_ " set _ is word
 
" ============================================================================
" Vim-plug initialization
" Avoid modify this section, unless you are very sure of what you are doing

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

" this needs to be here, so vim-plug knows we are declaring the plugins we
" want to use
call plug#begin('~/.vim/plugged')

" Plugins from github repos:
"""Plugin 'rosenfeld/conque-term'
"""" запуск интерпретатора на F5
""""nnoremap <F5> :ConqueTermSplit ipython<CR>
nnoremap <F5> :!./%<CR>
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
map <F4> :PymodeLint<CR>
let g:pymode_virtualenv = 1 "virtualenv 
let g:pymode_breakpoint = 1 "breakpoint <leader>b
let g:pymode_run_bind = '<F6>'

"=====================================================
Plug 'davidhalter/jedi-vim'           " Jedi-vim autocomplete plugin
" set completeopt-=menuone,preview " Disable doc autoshow
set completeopt=menuone,longest " Don't apply first completion
let g:jedi#popup_select_first = 0 " Disable choose first function/method at autocomplete
let g:jedi#popup_on_dot = 0 " Disable popup after dot
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
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '^__pycache__$', '^env$', '^.env$']

call plug#end()                       " required

" use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
	let &t_Co = 256
    colorscheme fisa
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText ctermbg=NONE
    hi LineNr ctermfg=0 ctermbg=NONE
else
    colorscheme delek
endif
" colors for gvim
if has('gui_running')
    colorscheme fisa
    hi Normal ctermfg=17 ctermbg=233 guibg=#222222
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
set noignorecase
" Increment search and highlight all
set incsearch
set hlsearch
" K is split line
function SplitLine()
    if getline(".")[col(".")-1] == ' '
        call feedkeys("r\<CR>")
    else
        call feedkeys("f\<Space>r\<CR>")
    endif
endfunction
nnoremap K :call SplitLine()<CR>
nnoremap <leader>h K
