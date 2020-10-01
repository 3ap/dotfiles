" .vimrc configuration by zar <sergey@nazaryev.ru>
set nocompatible
set langmap=ё`йqцwуeкrеtнyгuшiщoзpх[ъ]фaыsвdаfпgрhоjлkдlж\\;э'яzчxсcмvиbтnьmб\\,ю.Ё~ЙQЦWУEКRЕTНYГUШIЩOЗPХ{Ъ}ФAЫSВDАFПGРHОJЛKДLЖ:Э\\"ЯZЧXСCМVИBТNЬMЮ>Б<

nohl                                          " no highlight last search query in new files
set tabpagemax=100                            " maximum tab count is 100, not 10
set encoding=utf-8                            " always use utf-8
set t_Co=256                                  " 256-color terminal mode
set backspace=indent,eol,start                " allow backspacing over everything in insert mode
set smartindent                               " enable smart indent
set history=7000                              " keep 7000 lines of command line history
set colorcolumn=70                            " set colored column on 70 column
set textwidth=69                              " autosplit after 69 column
set mouse=n                                   " using mouse in terminal
set wildmode=list:longest,full                " sh-like autocompletion file names
set wildmenu                                  " enhanced cmd line completion
set ruler                                     " show the cursor position all the time
set nowrap                                    " don't wrap lines on screen
set shortmess=atI                             " don't show startup screen
set scrolloff=3                               " scroll before N lines to bottom
set number                                    " show line numbers
set showmatch                                 " show matching bracket
set title                                     " set window title as filename
set autoread                                  " automatically read file when it changed in external editor
set wrapscan                                  " search continues over end of file
set hlsearch                                  " highlight all search results
set incsearch                                 " increment search
set ignorecase                                " case-insensitive search
set smartcase                                 " uppercase causes case-sensitive search
set pastetoggle=<F3>                          " paste mode toggle by button
set laststatus=2                              " always show status line
"set timeoutlen=1000 ttimeoutlen=0             " no timeout after exit from visual mode
set nojoinspaces                              " only insert single space after a '.', '?' and '!' with a join command
set smarttab                                  " at start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
set expandtab                                 " convert all TAB to N spaces
set shiftwidth=4                              " where N is 4
set tabstop=4                                 " width of tab in number of space
set novisualbell                              " no visual and sound bell
set hidden                                    " allow buffer switching without saving
set virtualedit=onemore                       " allow for cursor beyond last character
set lazyredraw                                " no lags
set ttyfast                                   " no lags
set guicursor=
set spelllang=en
set completeopt+=preview

" Style settings
syntax on                                     " turn on syntax highlight
colorscheme elflord
hi Visual ctermfg=7 ctermbg=0 cterm=none
hi LineNr ctermfg=DarkGrey ctermbg=none

" Mappings
let mapleader=","
map <F2> <Esc>:!ctags -R<CR>
map q <Esc>:q<CR>
command! Cwd lcd %:p:h
command! Sudo w !sudo tee % >/dev/null
vnoremap < <gv
vnoremap > >gv
nnoremap s "_d
noremap <leader>ss :call StripTrailingWhitespace()<CR>
nnoremap <silent> <F11> :set spell!<cr>
inoremap <silent> <F11> <C-O>:set spell!<cr>
inoremap <Tab> <C-x><C-o>

" Use Tab for autocomplete, if not at beginning of line
"function! Tab_Or_Complete()
"  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"    return "\<C-N>"
"  else
"    return "\<C-x>\<C-O>"
"  endif
"endfunction
"inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" Strip trailing whitespace (,ss)
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

" Omni-complition
filetype plugin on
set omnifunc=syntaxcomplete#Complete

if has("autocmd")
  " settings for specific file types
  autocmd! FileType make setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80
  "autocmd! FileType c    setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80
  autocmd! FileType dts  setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80
  " jump to the last position when reopening a file
  autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " autoreload .vimrc
  autocmd! bufwritepost .vimrc source $MYVIMRC
  autocmd! bufwritepost init.vim source $MYVIMRC

  " autostrip trailing whitespaces
  autocmd! FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yaml,yml,perl,sql,vim,markdown autocmd BufWritePre <buffer> call StripTrailingWhitespace()

  " autodetect file type for syntax highlighting
  autocmd! BufEnter,InsertLeave * :filetype detect

  " match trailing whitespaces
  autocmd! BufEnter,InsertLeave * match Error /\s\+$/
endif

" Persistent undo
if has('persistent_undo')
    call system('mkdir -p ~/.vim/undo')
    set undodir=~/.vim/undo
    set undofile
endif

if has("nvim-0.5.0")
    packadd nvim-lsp
"    lua require'nvim_lsp'.rust_analyzer.setup{}
    lua require'nvim_lsp'.rls.setup{}
"    lua require'nvim_lsp'.clangd.setup{}

    let g:language_client_log_level = 'debug'

    function! LSPRename()
        let s:newName = input('Enter new name: ', expand('<cword>'))
        echom "s:newName = " . s:newName
        lua vim.lsp.buf.rename(s:newName)
    endfunction

    function! LSPSetMappings()
        setlocal omnifunc=v:lua.vim.lsp.omnifunc

        nnoremap <silent> <buffer> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
        nnoremap <silent> <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <silent> <buffer> K     <cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <silent> <buffer> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <silent> <buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <silent> <buffer> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
        nnoremap <silent> <buffer> gr    <cmd>lua vim.lsp.buf.references()<CR>
        nnoremap <silent> <buffer> gR    <cmd>lua vim.lsp.buf.rename()<CR>
    endfunction

    au FileType lua,sh,c,python,rust :call LSPSetMappings()
    "autocmd BufWritePre lua,sh,c,python,rust lua vim.lsp.buf.formatting_sync(nil, 1000)
endif
