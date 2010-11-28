" General
" VIM UI
" Colors and Fonts
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Command mode related
"    -> Moving around, tabs and buffers
"    -> Statusline
"    -> Parenthesis/bracket expanding
"    -> General Abbrevs
"    -> Spelling
"    -> Mouse Stuffs
"    -> Editing mappings
"
"    -> Cope
"    -> ZenCoding
"    -> Omni complete functions
"    -> Python section
"    -> JavaScript section
"
"
"
"

"==========================================================================
" General 
"----------------------------------------------------------------------------
    " Startup
    "au VimEnter *  NERDTree 	"Auto load Nerdtree
    "au VimEnter * wincmd p      "Take cursor to windows
    au BufEnter * lcd %:p:h

    ":cd E:\My Dropbox\Work\ 
    set magic 				" Set magic for Regex
    set cpoptions+=$ 		" set the $ at the end of change word
    
    set encoding=utf-8      " set unicode encoding for default
    set history=300
    set undolevels=1000     " ul:  lots and lots of undo

    set nocompatible        " nocp:  turn off vi compatibility
    
    filetype on
    filetype plugin on
    filetype indent on
    syntax on
    
    " Set auto read when the file is changed outside
    set autoread
    
    set showcmd			" display incomplete commands

    " Fast saving 
    map <leader>w :w!<cr>

    " Fast editing of the .vimrc
    :map <leader>s :source ~/.vimrc
    :map <leader>e :e ~/.vimrc
    " When vimrc is edited, reload it
    autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

"============================================================================
" VIM UI
"----------------------------------------------------------------------------
    set go+=b               " set horizontal scroll
    set undolevels=1000     " ul:  lots and lots of undo
    set modelines=20
    set autochdir 			" auto dir buffer and folder
    set number				" line numbers
    set backspace=indent,eol,start
    " Set 7 lines to the curors - when moving vertical..
    set so=7

    set wildmenu "Turn on WiLd menu

    set ruler "Always show current position

    set cmdheight=2 "The commandbar height

    set hid "Change buffer - without saving

    " Set backspace config
    set backspace=eol,start,indent
    set whichwrap+=<,>,h,l

    set ignorecase "Ignore case when searching

    set smartcase

    set hlsearch "Highlight search things

    set incsearch "Make search act like search in modern browsers

    set magic "Set magic on, for regular expressions

    set showmatch "Show matching bracets when text indicator is over them
    set mat=2 "How many tenths of a second to blink

    " No sound on errors
    set noerrorbells
    set novisualbell
    set t_vb=
        
" Colors and fonts
"----------------------------------------------------------------------------

    set fileencodings=utf-8,cp1251,koi8-r,cp866
    colorscheme miromiro

    if has("gui_running") 
        set gfn=Consolas:h10:cANSI
        set guioptions-=T 		" no toolbar 
        set guioptions-=m 		" no menu
    endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set nowrap
    set expandtab
    set shiftwidth=4
    set tabstop=4
    set smarttab

    set lbr
    set tw=500

    set ai "Auto indent
    set si "Smart indet

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    "Pressing ,ss will toggle and untoggle spell checking
    map <leader>ss :setlocal spell!<cr>

    "Shortcuts using <leader>
    map <leader>sn ]s
    map <leader>sp [s
    map <leader>sa zg
    map <leader>s? z

" -------------------------- Zencoding settings
let g:user_zen_expandabbr_key = '<c-z>,'
let g:use_zen_complete_tag = 1

"===============================================================
" Mapping
"---------------------------------------------------------------
    " select all
    map <c-a> ggVG
    set completeopt=menu,longest,preview
    set confirm
" Settings for taglist.vim
"let Tlist_Ctags_Cmd = 'd:\soft\Programming\GVimPortable\ctags\ctags.exe'
map <F4> :TlistToggle<cr>
map <F3> :NERDTreeToggle<cr>
"SuperTab config
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

"---------------------- HAML
au! BufRead,BufNewFile *.haml setfiletype haml

"---------------------- HTML

au Filetype html imap jquerylink <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.0/jquery-ui.js"></script>
au Filetype html imap jstag <script type="text/javascript" src=""><CR></script><up><tab>
au Filetype html imap beginhtml5 <!DOCTYPE html><CR><html lang="en"><CR><head><CR><title>untitled</title><CR><link rel="stylesheet" href="" type="text/css" media="screen" title="no title" charset="utf-8"><CR></head><CR><body><CR></body><CR></html>
au Filetype html imap jquerylink https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js

au filetype javascript set omnifunc=javascriptcomplete#CompleteJS
"---------------------- CPP

au Filetype cpp imap FF for(int i=0;i< ;++i);
au Filetype cpp imap cmt /* ---------------------------------------<CR><CR>   --------------------------------------- */

"---------------------- PHP
au Filetype php imap <php <php<CR>?>

"---------------------- Lorem
ab lorem Lorem ipsum dolor sit amet, consectetur <CR>
         \ adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore <CR>
         \ magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation <CR>
         \ ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute <CR>
         \ irure dolor in reprehenderit in voluptate velit esse cillum dolore eu <CR>
         \ fugiat nulla pariatur.  Excepteur sint occaecat cupidatat non <CR>
         \ proident, sunt in culpa qui officia deserunt mollit anim id est <CR>
         \ laborumkl
