" ============================================================================
" General
" ============================================================================

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8
set nocompatible              " be iMproved, required
set visualbell t_vb= " no sound 
set number " show line numbers
set relativenumber " relative
"  set iskeyword-=_ " set _ is word
set mouse=a
set wrap

" With a map leader it's possible to do extra key combinations
let mapleader = ","
 
" Set to auto read when a file is changed from the outside
set autoread

" Save when :!
set autowrite

" Fast saving
nnoremap <leader>w :w!<CR>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'silent! write !sudo tee % > /dev/null' <bar> edit!


" ============================================================================
" VIM user interface
" ============================================================================

" When scrolling, keep cursor 5 lines away from screen border
set scrolloff=5

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Remove delay after pressing ESC
set ttimeoutlen=0

" autocompletion of files and commands behaves like shell
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif


" ============================================================================
" Text, tab and indent related
" ============================================================================

" Expand tabs into spaces
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines


" ============================================================================
" Fast editing and reloading of vimrc configs
" ============================================================================
map <leader>e :e! ~/.vimrc<cr>
augroup myvimrchooks
    au!
    autocmd bufwritepost ~/.vimrc source ~/.vimrc
augroup END


" ============================================================================
" Visual mode related
" ============================================================================

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" ============================================================================
" Moving around, tabs, windows and buffers
" ============================================================================

" Smart way to move between windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Split shortcut
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" ============================================================================
" Search
" ============================================================================

" Searching is not case sensitive
set ignorecase

" If a pattern contains an uppercase letter, it is case sensitive,
" otherwise, it is not
set smartcase

" Increment search and highlight all
set incsearch
set hlsearch

" Disable highlight when <leader><CR> is pressed
map <silent> <leader><CR> :noh<CR>
map <silent> <leader><C-j> :noh<CR>

" Toggle ignorecase option
map <leader>/ :set ignorecase!<CR>


" ============================================================================
" Editing mappings
" ============================================================================

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line(s) of text
nmap <leader>j mz:m+<cr>`z
nmap <leader>k mz:m-2<cr>`z
vmap <leader>j :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>k :m'<-2<cr>`>my`<mzgv`yo`z


" ============================================================================
" Vim-plug initialization
" ============================================================================

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
" K is split line
function! SplitLine()
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
" nnoremap , ;
" nnoremap ; ,
" better indent, not lose selection
vnoremap > >gv
vnoremap < <gv
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
