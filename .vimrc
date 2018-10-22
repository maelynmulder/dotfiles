" A few sane defaults for use in ArchLabs

" Vim-plug 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
    Plug 'https://github.com/justinj/vim-pico8-syntax'
    "Plug 'https://github.com/godlygeek/csapprox'
    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/takac/vim-hardtime'
    Plug 'https://github.com/tpope/vim-surround'
call plug#end() 

" load Arch Linux defaults
runtime! archlinux.vim

" yank text to system clipboard (requires +clipboard)
set clipboard^=unnamedplus

" enable line numbers
set number

" ask confirmation for certain things like when quitting before saving
set confirm

" enable tab completion menu when using colon command mode (:)
set wildmenu

set shortmess+=aAcIws   " Hide certain messages like 'Search Hit Bottom' etc.
set expandtab           " Tab inserts Spaces not Tabs '\t'
set softtabstop=4       " Amount of spaces to enter when Tab is pressed
set shiftwidth=4        " 4 space indentation

" enable mouse, sgr is better but not every term supports it
set mouse=a
if has('mouse_sgr')
    set ttymouse=sgr
endif

" Enable Italics
let &t_ZH = "\e[3m"
let &t_ZR = "\e[23m"

" syntax highlighting with true colors in the terminal
syntax enable
colorscheme octagon 
hi Comment cterm=italic
hi Title cterm=italic
hi DiffText cterm=italic
hi StorageClass cterm=italic
hi Macro cterm=italic
hi SpecialKey cterm=italic
hi Keyword cterm=italic
if has('termguicolors')
    if &term =~? 'screen\|tmux'
        set t_8f=^[[38;2;%lu;%lu;%lum
        set t_8b=^[[48;2;%lu;%lu;%lum
    endif
    set termguicolors
endif

" bracketed paste while in insert mode, bracketed paste preserves indentation
inoremap <silent><C-v> <Esc>:set paste<CR>a<C-r>+<Esc>:set nopaste<CR>a

" better defaults
nnoremap 0 ^
nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <Tab> ==j
map <F5> :NERDTreeToggle<CR>
map <C-g> :split <CR>
map <C-v> :vsplit <CR>
let g:user_emmet_leader_key='<C-m>'

" better motions with wrapped text while preserving numbered jumps
for g:key in ['k', 'j', '<Up>', '<Down>']
    execute 'noremap <buffer> <silent> <expr> ' .
                \ g:key . ' v:count ? ''' .
                \ g:key . ''' : ''g' . g:key . ''''
    execute 'onoremap <silent> <expr> ' .
                \ g:key . ' v:count ? ''' .
                \ g:key . ''' : ''g' . g:key . ''''
endfor

augroup file_load_change_and_position
    " clear this group so they don't pile up
    autocmd!

    " when quitting, save position in file
    " when re-opening go to last position
    autocmd BufReadPost * call setpos(".", getpos("'\""))

    " Reload changes if file changed outside of vim
    " requires autoread (enabled by default)
    autocmd FocusGained,BufEnter * if mode() !=? 'c' | checktime | endif
    autocmd FileChangedShellPost * echo "Changes loaded from file"
augroup END 
