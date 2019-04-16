" ============================================================================
" General
" ============================================================================

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8

" With a map leader it's possible to do extra key combinations
let mapleader = ","

" Set to auto read when a file is changed from the outside
set autoread

" Save when :!
set autowrite

" Try to recognize the type of the file. Used for syntax highlighting, options
filetype on
" Load ftplugin.vim 
filetype plugin on
" Load indent.vim
filetype indent on

" Fast saving
nnoremap <leader>w :w!<CR>

" Fast quit
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'silent! write !sudo tee % > /dev/null' <bar> edit!

" Enable OS clipboard using, vim-gtk or vim-gtk3 package required
set clipboard=unnamed
set guioptions+=a
" imap <C-v> <C-r><C-o>*

" Always use vertical diffs
set diffopt+=vertical

" Allow backspacing autoindent
set backspace=indent,eol,start

set lazyredraw                        " Reduce the redraw frequency
set ttyfast                           " Send more characters in fast terminals


" ============================================================================
" VIM user interface
" ============================================================================

" When scrolling, keep cursor # lines away from screen border
set scrolloff=7

" Relative line numbers
set number
set relativenumber

" Display incomplete commands
set showcmd

" Mouse support
set mouse=a

" Highlight the 80s symbol in the line
highlight ColorColumn ctermbg=52
call matchadd('ColorColumn', '\%80v', 100)

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

highlight Comment cterm=italic gui=italic

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

" Wrap
set nowrap  " Don't wrap long lines
set listchars=extends:→  " Show arrow if line continues rightwards
set listchars+=precedes:←  " Show arrow if line continues leftwards

" Display extra whitespaces
set list listchars+=tab:»·,trail:·,nbsp:·


" ============================================================================
" Fast editing and reloading of vimrc configs
" ============================================================================
map <leader>e :e ~/.vimrc<cr>
augroup myvimrchooks
    autocmd!
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

" Better indent, not lose selection
vnoremap > >gv
vnoremap < <gv


" ============================================================================
" Moving around, tabs, windows and buffers
" ============================================================================

" Smart way to move between windows
nnoremap <down> <C-w>j
nnoremap <up> <C-w>k
nnoremap <right> <C-w>l
nnoremap <left> <C-w>h

" Split shortcut
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


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
" map <silent> <leader><CR> :noh<CR>
" map <silent> <leader><C-j> :noh<CR>

" Toggle ignorecase option
map <leader>/ :set ignorecase!<CR>

" Don't jump to original position after ESC
" nnoremap / :call ApplySearch()<CR>/
" nnoremap ? :call ApplySearch()<CR>?

" function! ApplySearch()
"     cnoremap <ESC> <CR> :noh<CR>:call UnmapEsc()<CR>
" endfunction
" 
" function! UnmapEsc()
"     cunmap <ESC>
" endfunction


" ============================================================================
" Editing mappings
" ============================================================================

" Remap VIM 0 to first non-blank character
nnoremap 0 ^
nnoremap ^ :normal! 0<CR>

" Move a line(s) of text
nmap <leader>j mz:m+<cr>`z
nmap <leader>k mz:m-2<cr>`z
vmap <leader>j :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>k :m'<-2<cr>`>my`<mzgv`yo`z

" Move cursor in insert mode
" inoremap <C-l> <Right>

" nnoremap <C-j> <C-d>
" nnoremap <C-k> <C-u>
nnoremap \ ,

" S is split line
nnoremap S :call SplitLine()<CR>

function! SplitLine()
    if getline(".")[col(".")-1] == ' '
        call feedkeys("r\<CR>")
    else
        call feedkeys("F\<Space>r\<CR>")
    endif
endfunction


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
" ============================================================================

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

let g:pymode_rope = 1
" Regenerate project cache on every save (if file has been modified)
" let g:pymode_rope_regenerate_on_write = 1
" Don't automatically insert
" set completeopt=menuone,noinsert
" Turn off code completion in INSERT mode
let g:pymode_rope_completion = 0

" let g:pymode_rope_complete_on_dot = 0
let g:pymode_lint_on_write = 0 "disable pylint check on save file
nnoremap <F4> :PymodeLint<CR>
nnoremap <leader><F4> :PymodeLintAuto<CR>
let g:pymode_virtualenv = 1 "virtualenv
let g:pymode_breakpoint = 1 "breakpoint <leader>b
let g:pymode_run_bind = '<F6>'
let g:pymode_doc_bind = '<F1>'

Plug 'davidhalter/jedi-vim'           " Jedi-vim autocomplete plugin
" set completeopt-=menuone,preview " Disable doc autoshow
set completeopt=menuone,longest " Don't apply first completion
let g:jedi#popup_select_first = 0 " Disable choose first function/method at autocomplete
let g:jedi#popup_on_dot = 0 " Disable popup after dot
" let g:jedi#documentation_command = '<F1>'

Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context' " Make it work like C-Space in jedi-vim
let g:SuperTabContextDefaultCompletionType = '<C-x><C-o>'
let g:SuperTabNoCompleteAfter = ['^', '\t', '\s\s']

" New search
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-fuzzyspell-/)
map z? <Plug>(incsearch-fuzzyspell-?)
map zg/ <Plug>(incsearch-fuzzyspell-stay)
autocmd VimEnter * IncSearchNoreMap <C-j> <CR>
autocmd VimEnter * IncSearchNoreMap <Esc> <CR>
let g:incsearch#auto_nohlsearch = 1
nnoremap <leader><Esc> :<C-u>nohlsearch<CR>

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

" folding
Plug 'tmhedberg/SimpylFold'
set foldlevel=1
" accordion expand traversal of folds
nnoremap <silent> z] :<C-u>silent! normal! zc<CR>zjzozz
nnoremap <silent> z[ :<C-u>silent! normal! zc<CR>zkzo[zzz

" Ctrl P
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-f>'
" The Silver Searcher
" brew install the_silver_searcher
" apt-get install silversearcher-ag
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " bind \ (backward slash) to grep shortcut
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap <leader>a :Ag<SPACE>

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Ack
" Plug 'mileszs/ack.vim'
" let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated env venv'
" set grepprg=/bin/grep\ -nH
augroup myvimrchooks2
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

" Git wrapper
Plug 'tpope/vim-fugitive'

call plug#end()                       " required

" use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
    let &t_Co = 256
    colorscheme fisa
    hi Normal ctermbg=NONE ctermfg=255
    hi NonText ctermbg=NONE
    hi LineNr ctermbg=NONE
else
    colorscheme delek
endif
" colors for gvim
if has('gui_running')
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 9
    set guicursor+=a:blinkon0 " disable blinking cursor
    colorscheme fisa
    hi Normal guifg=#eeeeee guibg=#202020
endif


" ============================================================================
" Install plugins the first time vim runs
" ============================================================================

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif


" ============================================================================
" Another layout support in normal mode
" ============================================================================

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
nmap Ж :
nmap Н Y
nmap з p
nmap ф a
nmap щ o
nmap г u
nmap З P
