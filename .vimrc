" --- Plugin Management ---
call plug#begin('~/.vim/plugged')  " Start defining plugins

" Essential Plugins"
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }        " Fuzzy finder (Install using :PlugInstall fzf)
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'             " File tree explorer
Plug 'tpope/vim-fugitive'             " Git integration
Plug 'airblade/vim-gitgutter'         " Git diff in the gutter

" Additional Plugins (optional)"
Plug 'vim-airline/vim-airline'         " Status bar enhancer
Plug 'tpope/vim-surround'              " Easy manipulation of surrounding characters
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }  " Use :NERDTreeToggle to open/close NERDTree

call plug#end()                       " End of plugin definitions

" --- General Settings ---
set nocompatible              " Disable vi compatibility mode
set encoding=utf-8           " Use UTF-8 encoding
set nobomb                    " Don't write byte order mark (BOM)
set number                    " Show line numbers
set relativenumber            " Use relative line numbers
set cursorline                " Highlight the current line
set wildmenu                  " Enhanced command-line completion
set showcmd                   " Show (partial) command being typed
set laststatus=2              " Always show the status line
set ruler                     " Show the cursor position in the status line
set showmode                  " Display the current mode
set title                     " Set the title of the window to the filename
set mouse=a                   " Enable mouse support in all modes
set clipboard=unnamedplus     " Use system clipboard by default (macOS)
set hidden                    " Allow unsaved buffers to be hidden (for better IDE integration)

" --- Indentation and Whitespace ---
set tabstop=4                 " Number of spaces that a <Tab> in the file counts for.
set softtabstop=4             " Number of spaces that a <Tab> counts for while editing.
set shiftwidth=4              " Number of spaces to use for auto indentation.
set expandtab                 " Convert tabs to spaces.
set autoindent                " Copy indent from current line when starting a new line.
set copyindent                " Copy the previous indentation on autoindenting.
set shiftround                " Round indent to multiple of 'shiftwidth'.
set list                      " Show whitespace characters
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_ " Customize whitespace characters
set wrap                      " Enable line wrapping

" --- Searching ---
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search as you type
set ignorecase                " Ignore case in search patterns
set smartcase                 " Ignore case if search pattern is all lowercase, case-sensitive otherwise

" --- File and Backup Settings ---
set backupdir=~/.vim/backups  " Directory to store backup files
set directory=~/.vim/swaps    " Directory to store swap files
set undodir=~/.vim/undo       " Directory to store undo history
set backupskip=/tmp/*,/private/tmp/* " Don't create backups in temporary directories
set undofile                  " Enable persistent undo

" --- Appearance ---
set background=dark           " Set background to dark for Solarized Dark
colorscheme solarized         " Use the Solarized Dark color scheme
let g:solarized_termtrans=1   " Enable transparency in terminal

" --- Scrolling ---
set scrolloff=3               " Start scrolling 3 lines before the cursor reaches the top/bottom

" --- Custom Functions ---
" Strip trailing whitespace
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" --- Automatic Commands ---
filetype plugin indent on       " Enable filetype detection, plugins, and indentation
" Treat .json files as .js
au BufNewFile,BufRead *.json setfiletype json syntax=javascript
" Treat .md files as Markdown
au BufNewFile,BufRead *.md setfiletype markdown

" --- Disable netrw to avoid conflicts with IDE file explorers ---
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" --- Plugin Configuration ---
let g:airline_powerline_fonts = 1  " Use Powerline fonts for vim-airline (if available)
nnoremap <leader>n :NERDTreeToggle<CR> " Open/Close NERDTree with <leader>n

" --- Fuzzy Finder (fzf) Integration ---
" (Add your preferred fzf key mappings here)
