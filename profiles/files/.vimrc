"
" === Interface ===============================================================
"

set ruler          " Show row and column ruler information
set number         " Show line numbers

set linebreak      " Break lines at word (requires Wrap lines)
set showbreak=+++  " Wrap-broken line prefix
set textwidth=100  " Line wrap (number of cols)

set showmatch      " Highlight matching brace
set hlsearch       " Highlight all search results
set smartcase      " Enable smart-case search
set ignorecase     " Always case-insensitive
set incsearch      " Searches for strings incrementally

set noerrorbells   " Turn off error sounds
set novisualbell   " Turn off error flashes

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

set foldcolumn=1   " Add a bit of margin to the left
set so=7           " Set 7-lines of buffer when scrolling

set laststatus=2   " Always show the status line

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"
" === Colors / Fonts ==========================================================
"

syntax enable        " Turn on syntax highlighting
set background=dark  " Set the background dark



"
" === Formatting ==============================================================
"

set encoding=utf8  " Set UTF-8 as the standard encoding

set expandtab      " Use spaces instead of tabs
set smarttab       " Enable smart-tabs

" Set tabs to 2 spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2

set ai             " Auto indent
set si             " Smart indent
set wrap           " Wrap lines

" Linebreak on 500 characters
set lbr
set tw=500



"
" === I/O =====================================================================
"

set ffs=unix,dos,mac         " Use Unix as the standard file type
set autoread                 " Update files if modified outside of the editor
set wildignore=*.o,*~,*.pyc  " Ignore compiled files

" Ignore common hidden files and folders
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Turn off backups (since everything is already backed up)
set nobackup
set nowb
set noswapfile

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm



"
" === Functionality ===========================================================
"

set undolevels=1000             " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
set lazyredraw                  " Prevent redraw when executing macros



"
" === Helper Functions ========================================================
"

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
