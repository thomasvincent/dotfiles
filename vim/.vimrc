" .vimrc
" Author: Thomas Vincent
" GitHub: https://github.com/thomasvincent/dotfiles
"
" This file contains Vim configuration.

" General settings
set nocompatible                " Use Vim settings, rather than Vi settings
filetype plugin indent on       " Enable file type detection
syntax enable                   " Enable syntax highlighting
set encoding=utf-8              " Set encoding to UTF-8
set fileencoding=utf-8          " Set file encoding to UTF-8
set fileencodings=utf-8         " Set file encodings to UTF-8
set ttyfast                     " Faster redrawing
set lazyredraw                  " Only redraw when necessary
set history=1000                " Set history to 1000 commands
set showcmd                     " Show incomplete commands
set showmode                    " Show current mode
set backspace=indent,eol,start  " Allow backspacing over everything in insert mode
set hidden                      " Allow buffer switching without saving
set autoread                    " Reload files changed outside vim
set mouse=a                     " Enable mouse in all modes
set report=0                    " Always report changed lines
set noerrorbells                " No error bells
set novisualbell                " No visual bells
set t_vb=                       " No visual bells
set tm=500                      " Set timeoutlen to 500
set ttimeoutlen=10              " Set ttimeoutlen to 10
set updatetime=300              " Set updatetime to 300
set shortmess+=c                " Don't pass messages to |ins-completion-menu|
set signcolumn=yes              " Always show signcolumn
set clipboard=unnamed           " Use system clipboard
set autowrite                   " Automatically write a file when leaving a modified buffer
set autowriteall                " Automatically write all files when leaving a modified buffer
set complete-=i                 " Don't scan included files
set nrformats-=octal            " Don't use octal numbers
set sessionoptions-=options     " Don't save options in sessions
set viewoptions-=options        " Don't save options in views
set formatoptions+=j            " Delete comment character when joining commented lines
set shell=/bin/zsh              " Set shell to zsh

" UI settings
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set ruler                       " Show the cursor position all the time
set cursorline                  " Highlight current line
set wrap                        " Wrap lines
set linebreak                   " Wrap lines at convenient points
set showmatch                   " Show matching brackets
set matchtime=2                 " Show matching brackets for 0.2 seconds
set matchpairs+=<:>             " Add HTML brackets to pair matching
set scrolloff=3                 " Minimum lines to keep above and below cursor
set sidescrolloff=5             " Minimum columns to keep to the left and right of cursor
set display+=lastline           " Show as much as possible of the last line
set cmdheight=2                 " Better display for messages
set wildmenu                    " Better command-line completion
set wildmode=list:longest,full  " Complete files like a shell
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " Ignore compiled files
set wildignore+=*.DS_Store      " Ignore macOS files
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.webp " Ignore image files
set wildignore+=*.pdf,*.zip,*.tar.gz " Ignore archive files
set wildignore+=*.pyc,*.pyo     " Ignore Python compiled files
set wildignore+=*.class         " Ignore Java compiled files
set wildignore+=*/node_modules/* " Ignore node_modules
set wildignore+=*/.git/*        " Ignore git files
set wildignore+=*/.hg/*,*/.svn/* " Ignore version control files
set wildignore+=*/vendor/*      " Ignore vendor files
set wildignore+=*/dist/*        " Ignore dist files
set wildignore+=*/build/*       " Ignore build files
set wildignore+=*/coverage/*    " Ignore coverage files
set wildignore+=*/__pycache__/* " Ignore Python cache files
set wildignore+=*.swp,*.bak     " Ignore swap and backup files
set wildignore+=*.aux,*.out,*.toc " Ignore LaTeX files
set wildignore+=*.mp3,*.mp4,*.mov,*.flv,*.avi,*.wmv " Ignore media files
set laststatus=2                " Always show the status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}
set showtabline=2               " Always show the tabline
set noshowmode                  " Don't show the current mode (lightline will do that)
set title                       " Show the filename in the window titlebar
set titlestring=%F              " Show the full path of the file in the window titlebar
set titleold="Terminal"         " Set the title to "Terminal" when exiting Vim
set titlelen=95                 " Set the title length to 95
set colorcolumn=80,120          " Show a column at 80 and 120 characters
set list                        " Show invisible characters
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:× " Show invisible characters
set fillchars+=vert:│           " Set vertical split character
set splitbelow                  " Horizontal splits open below current window
set splitright                  " Vertical splits open to the right of the current window
set background=dark             " Use dark background
colorscheme desert              " Use desert colorscheme (built-in)

" Indentation settings
set autoindent                  " Auto-indent new lines
set smartindent                 " Enable smart-indent
set smarttab                    " Enable smart-tabs
set shiftwidth=4                " Number of auto-indent spaces
set softtabstop=4               " Number of spaces per Tab
set tabstop=4                   " Number of spaces per Tab
set expandtab                   " Use spaces instead of tabs
set shiftround                  " Round indent to multiple of 'shiftwidth'

" Search settings
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search results
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uppercase present
set magic                       " For regular expressions turn magic on
set gdefault                    " Use 'g' flag by default with :s/foo/bar/

" Folding settings
set foldenable                  " Enable folding
set foldmethod=indent           " Fold based on indent
set foldlevelstart=10           " Open most folds by default
set foldnestmax=10              " 10 nested fold max

" Backup settings
set backup                      " Enable backups
set backupdir=~/.vim/backup//   " Backup directory
set directory=~/.vim/swap//     " Swap directory
set undodir=~/.vim/undo//       " Undo directory
set undofile                    " Enable persistent undo
set writebackup                 " Write backup before overwriting a file
set backupcopy=yes              " Overwrite the original backup file

" Create directories if they don't exist
if !isdirectory(expand('~/.vim/backup'))
    call mkdir(expand('~/.vim/backup'), 'p')
endif
if !isdirectory(expand('~/.vim/swap'))
    call mkdir(expand('~/.vim/swap'), 'p')
endif
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p')
endif

" Key mappings
let mapleader = ','             " Set leader key to comma
let maplocalleader = '\\'       " Set local leader key to backslash

" Disable arrow keys (force good habits)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Move by visual line, not actual line
nnoremap j gj
nnoremap k gk

" Quickly edit/reload the vimrc file
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Clear search highlighting
nnoremap <leader><space> :noh<CR>

" Toggle paste mode
nnoremap <leader>p :set paste!<CR>

" Toggle line numbers
nnoremap <leader>n :set number!<CR>

" Toggle relative line numbers
nnoremap <leader>rn :set relativenumber!<CR>

" Toggle wrap
nnoremap <leader>w :set wrap!<CR>

" Toggle list
nnoremap <leader>l :set list!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle cursor line
nnoremap <leader>cl :set cursorline!<CR>

" Toggle cursor column
nnoremap <leader>cc :set cursorcolumn!<CR>

" Toggle colorcolumn
nnoremap <leader>cc :set colorcolumn=80,120<CR>
nnoremap <leader>cC :set colorcolumn=<CR>

" Toggle syntax highlighting
nnoremap <leader>sy :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax enable <Bar> endif<CR>

" Toggle line highlighting
nnoremap <leader>hl :set cursorline!<CR>

" Toggle column highlighting
nnoremap <leader>hc :set cursorcolumn!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line numbers
nnoremap <leader>nu :set number!<CR>

" Toggle relative line numbers
nnoremap <leader>rnu :set relativenumber!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :set ignorecase!<CR>

" Toggle smart case
nnoremap <leader>sc :set smartcase!<CR>

" Toggle line wrapping
nnoremap <leader>wr :set wrap!<CR>

" Toggle line breaking
nnoremap <leader>lb :set linebreak!<CR>

" Toggle list mode
nnoremap <leader>li :set list!<CR>

" Toggle paste mode
nnoremap <leader>pa :set paste!<CR>

" Toggle spell checking
nnoremap <leader>sp :set spell!<CR>

" Toggle search highlighting
nnoremap <leader>hl :set hlsearch!<CR>

" Toggle case sensitivity
nnoremap <leader>ic :
