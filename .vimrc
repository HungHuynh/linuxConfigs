" Original author: amix.dk
" Modified by nXqd
" Update: 30/6/2011 4:17 AM
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
"    -> Editing mappings
"
"    -> Plugins
"       -> Cope
"       -> NERDTree plugin
"       -> Minibuffer plugin
"       -> MRU plugin
"       -> Command-T plugin
"       -> Omni complete functions
"       -> cTags plugins
"    -> Languages
"       -> Python section
"       -> JavaScript section
"       -> HTML section
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check if which os gvim runs
let win = 0
if has("win32")
    let win = 1
endif

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin on
filetype indent on

" Remap leader
let g:mapleader = ","

" edit vimrc according to os
if win
    map <leader>e :e! D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc
else
    map <leader>e :e! ~/.vimrc<cr>
endif

nmap <leader>w : w!<cr>

" When vimrc is edited, reload it
if win
    autocmd! bufwritepost _vimrc source D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc
else
    autocmd! bufwritepost .vimrc source ~/.vimrc
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set so=7                       " Set 7 lines to the curors - when moving vertical..
set wildmenu                   " Turn on WiLd menu
set ruler                      " Always show current position
set cmdheight=1                " The commandbar height
set hid                        " Change buffer - without saving
set nonu                       " No line number

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search
set ignorecase                 " Ignore case when searching
set smartcase
set hlsearch                   " Highlight search things
set incsearch                  " Make search act like search in modern browsers
set nolazyredraw
set magic                      " Set magic on, for regular expressions
set showmatch                  " Show matching bracets when text indicator is over them
set mat=2                      " How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax hilight
syntax enable

" Set font according to system
if win
   set gfn=Consolas:h10
   set shell=powershell.exe
else
    set gfn=Monospace\ 10
    set shell=/bin/bash
endif


if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    colorscheme twilight
else
    colorscheme zellner
    set background=dark
endif

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types
set list listchars=tab:\|-,trail:ˇ,extends:ť,precedes:Ť

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
    if win
        set undodir=C:\Windows\Temp
    else
        set undodir=~/.vim_runtime/undodir
    endif

    set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" display indentation guides
set list listchars=tab:\|ˇ,trail:.,extends:ť,precedes:Ť,nbsp:×

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set lbr
set tw=500

set ai             " Auto indent
set si             " Smart indent
set nowrap         " Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Use Ctrl+r to replace the selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" from an idea by michael naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
cno $q <C-\>eDeleteTillSlash()<cr>

" map select all text to C-A
noremap <C-A> ggVG

" Useful on some European keyboards
map ˝ $
imap ˝ $
vmap ˝ $
cmap ˝ $

func! Cwd()
    let cwd = getcwd()
    return "e " . cwd 
endfunc

func! DeleteTillSlash()
    let g:cmd = getcmdline()
    if !win
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    endif
    if g:cmd == g:cmd_edited
        if !win
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        endif
    endif   
    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


map <leader>bd :bdelete<cr>
map <leader>bc :Bclose<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Specify the behavior when switching between buffers 
try
    set switchbuf=usetab
    set stal=2
catch
endtry


""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap ( ()<left>
inoremap { {}<left>
inoremap [ []<left>
inoremap " ""<left>
inoremap ' ''<left>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z


"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set guitablabel=%t

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>


""""""""""""""""""""""""""""""
" => NERDTree plugin
""""""""""""""""""""""""""""""
map <leader>o :NERDTreeToggle<cr>

""""""""""""""""""""""""""""""
" => Minibuffer plugin
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 15
let g:miniBufExplSplitBelow=1

let g:bufExplorerSortBy = "name"

autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>u :TMiniBufExplorer<cr>

""""""""""""""""""""""""""""""
" => Yankring blugin
""""""""""""""""""""""""""""""
nnoremap <silent> <F11> :YRShow<CR>

""""""""""""""""""""""""""""""
" => MRU blugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>r :MRU<CR>

""""""""""""""""""""""""""""""
" => Command-T
""""""""""""""""""""""""""""""
let g:CommandTMaxHeight = 15
set wildignore+=*.o,*.obj,.git,*.pyc
noremap <leader>j :CommandT<cr>
noremap <leader>y :CommandTFlush<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType sass set omnifunc=csscomplete#CompleteCSS
autocmd FileType sss set omnifunc=csscomplete#CompleteCSS


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => cTags plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if win
    let Tlist_Ctags_Cmd='d:\Dropbox\apps\gVimPortable\ctags\ctags.exe'
endif
map <leader>t :TlistToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

""""""""""""""""""""""""""""""
" => Php section
""""""""""""""""""""""""""""""
" PHP Autocomplete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
set ofu=syntaxcomplete#Complete


""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 


""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
" disable log
let g:js_indent_log = 0
"au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> AJS.log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return 
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

""""""""""""""""""""""""""""""
" => HTML section
""""""""""""""""""""""""""""""
if win
    nmap <silent> <Leader>b :!start C:\Users\Administrator\AppData\Local\Google\Chrome\Application\chrome.exe %
else
    nmap <silent> <Leader>b :!chromium-browser --user-data-dir=~/.chromium % &
endif
