"*** user defined functions *** {{{1

  fun! LoadDjangoMapping() "{{{2
    let g:last_relative_dir = ''
    nnoremap \0 :sp settings.py<cr>
    nnoremap \9 :sp urls.py<cr>
    nnoremap \8 :sp templates/<cr>
    nnoremap \1 :call RelatedFile ("models.py")<cr>
    nnoremap \2 :call RelatedFile ("views.py")<cr>
    nnoremap \3 :call RelatedFile ("urls.py")<cr>
    nnoremap \4 :call RelatedFile ("admin.py")<cr>
    nnoremap \5 :call RelatedFile ("test.py")<cr>
    nnoremap \7 :call RelatedFile ("templatetags/")<cr>

  endfun 
  
  fun! RelatedFile(file)
    "This is to check that the directory looks djangoish
    if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/") 
      exec "edit %:h/" . a:file
      let g:last_relative_dir = expand("%:h") . '/'
      return ''
    else
      let g:last_relative_dir = ''
    endif

    if g:last_relative_dir != ''
      exec "edit " . g:last_relative_dir . a:file
      return ''
    endif

    echo "Cant determine where relative files is :" . a:file
    return ''
  endfun

  "}}}2

  function! ToggleSyntax() "{{{2
    if exists("g:syntax_on")
      syntax off
    else
      syntax on
    endif
  endfunction "}}}2
  
  function! CapitalizeCenterAndMoveDown() "{{{2
    s/\<./\u&/g
    center
    +1
  endfunction "}}}2 

  function! CreateXMLTag(tagName) "{{{2
    let a:tagStart = '<'.a:tagName.'>'
    let a:tagEnd = '</'.a:tagName.'>'
    return a:tagStart.a:tagEnd."\<ESC>2ba"
  endfunction "}}}2

  " smart complete function {{{2
  " Table of completion specifications (a list of lists) ...
  "let s:completions = []
  ""Function to add user-defined completions ..."
  "function! AddCompletion (left, right, completion, restore)
    "call insert(s:completions, [a:left, a:right, a:completion, a:restore])
  "endfunction

  "let s:NONE = ""

  ""Table of completions ...

  "call AddCompletion('{', s:NONE, "}", 1)
  "call AddCompletion('{', '}', "\<CR>\<C-D>\<ESC>O", 0)
  "call AddCompletion('\[', s:NONE, "]", 1)
  "call AddCompletion('\[', '\]', "\<CR>\<ESC>O\<TAB>", 0)
  "call AddCompletion('(', s:NONE, ")", 1)
  "call AddCompletion('(', ')', "\<RIGHT>", 0)
  "call AddCompletion('<', s:NONE, ">", 1)
  "call AddCompletion('<', '>', "\<CR>\<ESC>O\<TAB>", 0)
  "call AddCompletion('/\*', s:NONE, "*/", 1)
  "call AddCompletion('/\*', '\*/', "\<CR>* \<CR>\<ESC>\<UP>A", 0)

  "function! SmartComplete ()
    ""remember where we parked
    "let cursorpos = getpos('.')
    "let cursorcol = cursorpos[2]
    "let curr_line = getline('.')

    ""Special subpattern to match only at cursor position ...
    "let cur_pos_path = '\%'. cursorcol . 'c'
    ""Tab as usual at the left margin ...
    "if curr_line =~ '^\s*' . cur_pos_path
      "return "\<TAB>"
    "endif

    ""How to restore the cursor position ...
    "let cursor_back = "\<C-O>:call setpos('.'," . string(cursorpos) . ")\<CR>"

    ""if a matching smart completion has been specified, use that ...
    "for [left, right, completion, restore] in s:completions
        "let pattern = left . cur_pos_path . right
        "if curr_line =~ pattern
          "" Code around bug in setpos() when used at EOL ...
          "if cursorcol == strlen(curr_line)+1 && strlen(completion) == 1
            "let cursor_back = "\<LEFT>"
          "endif

          "" Return the completion...
          "return completion . (restore ? cursor_back : "")
        "endif
    "endfor
    
    ""If no contextual match and after an identifier, do keyword completion...
    "if curr_line =~ '\k' . cur_pos_path
      "return "\<C-N>"
    ""otherwise, just be a <TAB>
    "else
      "return "\<TAB>"
    "endif
  
  "endfunction 
  "}}}2

function! JavaScriptFold()  "{{{2
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
    "syn region foldBraces2 start=/[/ end=/]/ transparent fold keepend extend

    function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction "}}}2 

command! Bclose call <SID>BufcloseCloseIt() "{{{2
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
endfunction "}}}2

" *** OnlineDoc *** {{{2
function! OnlineDoc() 
        let s:browser = "chromium-browser"
        let s:wordUnderCursor = expand("<cword>") 

        if &ft == "cpp" || &ft == "c" || &ft == "ruby" || &ft == "php" || &ft == "python" 
                let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor."+lang:".&ft
        elseif &ft == "vim"
                let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor
        else 
                return 
        endif 

        let s:cmd = "silent !" . s:browser . " " . s:url 
        "echo  s:cmd 
        execute  s:cmd 
        redraw!
endfunction "}}}2

" *** git blame current line *** {{{2
function! GitBlameLine()
        let s:line_num = line('.')
        let s:cmd = "!git blame -L" . s:line_num . "," . s:line_num . " %"
        execute s:cmd
endfunction " }}}2

"end of user defined functions}}}1

"*** basic *** {{{1
  set hlsearch                  " higlight search result
  set cursorline                " display underline row on which cursor move
  set history=300               " remember last 300 commands
  set autoread
  "set number
  set tw=78
  colorscheme elflord
  call pathogen#infect()
  syntax on
  filetype on
  filetype plugin on
  set directory=~/.tmp
  ""au BufWinLeave * mkview
  ""au BufWinEnter * silent loadview
" }}}1

"*** Spell checking *** {{{1
  map <leader>sp :setlocal spell!<cr>
"}}}1

"*** Python *** {{{1
  au FileType python set nocindent
  let python_highlight_all=1
  "au FileType python syn keyword pythonDecorator True None False self

  au FileType python map <buffer> <leader>1 /class
  au FileType python map <buffer> <leader>2 /def
  au FileType python map <buffer> <leader>pp :!pep8 %<cr>
"}}}1

"*** htmldjango *** {{{1
au FileType htmldjango set tw=0
"}}}1

"*** Cope *** {{{1
  map <leader>vv :botright cope<cr>
  map <leader>nc :cn<cr>
  map <leader>pc :cp<cr>
"}}}1

"*** General abbrevation ***{{{1
  iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
  iab xauthor @author nyamba, (t.nyambayar@gmail.com)<cr>
"}}}1

"*** key mapping ***{{{1
  let mapleader=','
  let g:mapleader=','
  nmap <Leader>w :w!<cr>
  nmap <Leader>q :q<cr>
  nmap <Leader>cv :!cat % \| xclip -i -selection clipboard<cr>
  nmap <Leader>nh :nohlsearch<cr>
  nmap <Leader>on :on<cr>
  nmap <Leader>ff :CoffeeCompile vert<cr>
  map <Leader>e :e! ~/.vimrc<cr>
  map <Leader>ce :source ~/.vimrc<cr>
  map <Leader>, :MiniBufExplorer<cr>
  nnoremap <space> za
  nnoremap <F8> :setl noai nocin nosi inde=<CR>
  set pastetoggle=<F2>
  nmap <silent> ;s :call ToggleSyntax()<CR>
  nmap <silent> \c :call CapitalizeCenterAndMoveDown()<CR>
  imap <silent> <C-D><C-D> <C-R>=strftime("%e %b %Y")<CR>
  map <right> :bn<cr>
  map <left> :bp<cr>
  map <leader>bd :Bclose<cr>
  map <leader>ba :1,300 bd!<cr>
  " online doc search 
  map <Leader>k :call OnlineDoc()<CR>
  map <F2>:1,$!xmllint --format -<CR>
 "inoremap <silent> <TAB> <C-R>=SmartComplete()<CR>
  "}}}1

"*** Window ****{{{1
  set nocompatible
  set wildmode=list:longest
  set noinsertmode
  set cmdheight=2
  set nowrap
  set title
  "}}}1

"*** Statusbar ***{{{1
  set showcmd
  set laststatus=2 
  set statusline =[%n]
  set statusline+=%<%F
  set statusline+=%m 
  set statusline+=%r 
  set statusline+=%w 
  set statusline+=[%{&fileformat}] 
  set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}] 
  set statusline+=%y 
  set statusline+=%= 
  set statusline+=[ASCII=%B] 
  set statusline+=[COL=%c,L=%l/%L] 
  set statusline+=[%p%%] 
  "}}}1

"*** Tabstops ***{{{1
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
  set expandtab
  "set smarttab
  "}}}1

"*** Indentation ***{{{1
  set smartindent
  set showmatch
  set backspace=indent,eol,start
  set nolist
  set backspace=2
  filetype indent on
  "}}}1

"*** folding ***{{{1
  let g:xml_syntax_folding=1
  set foldmethod=syntax
  set fdc=4
  "}}}1

"*** TagList ***{{{1
  " F4: Switch on/off TagList
  nnoremap <silent> <F4> :TlistToggle<CR>
  " TagListTagName - Used for tag names
  "highlight MyTagListTagName gui=bold guifg=Black guibg=Orange
  " TagListTagScope - Used for tag scope
  "highlight MyTagListTagScope gui=NONE guifg=Blue
  " TagListTitle - Used for tag titles
  "highlight MyTagListTitle gui=bold guifg=DarkRed guibg=LightGray
  " TagListComment - Used for comments
  "highlight MyTagListComment guifg=DarkGreen
  " TagListFileName - Used for filenames
  "highlight MyTagListFileName gui=bold guifg=Black guibg=LightBlue
  "let Tlist_Ctags_Cmd = $VIM.'/vimfiles/ctags.exe' " location of ctags tool
  let Tlist_Show_One_File = 1 " Displaying tags for only one file~
  let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself
  let Tlist_Use_Right_Window = 1 " split to the right side of the screen
  "let Tlist_Sort_Type = "order" " sort by order or name
  let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
  let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
  let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
  let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
  let Tlist_Close_On_Select = 1 " Close the taglist window when a file or tag is selected.
  let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
  let Tlist_WinWidth = 30
  let Tlist_Inc_Winwidth = 0
  " let Tlist_Ctags_Cmd = 'ctags --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++'
  " very slow, so I disable this
  " let Tlist_Process_File_Always = 1 " To use the :TlistShowTag and the :TlistShowPrototype commands without the taglist window and the taglist menu, you should set this variable to 1.
  ":TlistShowPrototype [filename] [linenumber]
"}}}1

"*** OmniComplette ***{{{1
  " set Ctrl+j in insert mode, like VS.Net
  imap <C-j> <C-X><C-O>
  " :inoremap <expr> <CR> pumvisible() ? "\<c-y>" : "\<c-g>u\<CR>"
  " set completeopt as don't show menu and preview
  set completeopt=menuone
  " Popup menu hightLight Group
  highlight Pmenu ctermbg=13 guibg=LightGray
  highlight PmenuSel ctermbg=7 guibg=DarkBlue guifg=White
  highlight PmenuSbar ctermbg=7 guibg=DarkGray
  highlight PmenuThumb guibg=Black
  " use global scope search
  let OmniCpp_GlobalScopeSearch = 1
  " 0 = namespaces disabled
  " 1 = search namespaces in the current buffer
  " 2 = search namespaces in the current buffer and in included files
  let OmniCpp_NamespaceSearch = 1
  " 0 = auto
  " 1 = always show all members
  let OmniCpp_DisplayMode = 1
  " 0 = don't show scope in abbreviation
  " 1 = show scope in abbreviation and remove the last column
  let OmniCpp_ShowScopeInAbbr = 0
  " This option allows to display the prototype of a function in the abbreviation part of the popup menu.
  " 0 = don't display prototype in abbreviation
  " 1 = display prototype in abbreviation
  let OmniCpp_ShowPrototypeInAbbr = 1
  " This option allows to show/hide the access information ('+', '#', '-') in the popup menu.
  " 0 = hide access
  " 1 = show access
  let OmniCpp_ShowAccess = 1
  " This option can be use if you don't want to parse using namespace declarations in included files and want to add namespaces that are always used in your project.
  let OmniCpp_DefaultNamespaces = ["std"]
  " Complete Behaviour
  let OmniCpp_MayCompleteDot = 0
  let OmniCpp_MayCompleteArrow = 0
  let OmniCpp_MayCompleteScope = 0
  " When 'completeopt' does not contain "longest", Vim automatically select the first entry of the popup menu. You can change this behaviour with the OmniCpp_SelectFirstItem option.
  let OmniCpp_SelectFirstItem = 0

"}}}1

"*** NERDtree ***{{{1
  let g:NERDTreeQuitOnOpen = 1
  let NERDTreeIgnore = ['\.pyc$', '\~$']
  nmap <silent> <c-n> :NERDTreeToggle<CR>
"}}}1

"*** miniBuf ***{{{1
  let g:miniBufExplTabWrap = 1 " make tabs show complete (no broken on two lines)
  let g:miniBufExplModSelTarget = 1 " If you use other explorers like TagList you can (As of 6.2.8) set it at 1:
  "let g:miniBufExplUseSingleClick = 1 " If you would like to single click on tabs rather than double clicking on them to goto the selected buffer.
  let g:miniBufExplMaxSize = 1 " <max lines: defualt 0> setting this to 0 will mean the window gets as big as needed to fit all your buffers.
  "let g:miniBufExplForceSyntaxEnable = 1 " There is a Vim bug that can cause buffers to show up without their highlighting. The following setting will cause MBE to
  "let g:miniBufExplorerMoreThanOne = 1 " Setting this to 0 will cause the MBE window to be loaded even
  "let g:miniBufExplMapCTabSwitchBufs = 1
  "let g:miniBufExplMapWindowNavArrows = 1
  "for buffers that have NOT CHANGED and are NOT VISIBLE.
  "highlight MBENormal guibg=LightGray guifg=DarkGray
  " for buffers that HAVE CHANGED and are NOT VISIBLE
  "highlight MBEChanged guibg=Red guifg=DarkRed
  " buffers that have NOT CHANGED and are VISIBLE
  "highlight MBEVisibleNormal term=bold cterm=bold gui=bold guibg=Gray guifg=Black
  " buffers that have CHANGED and are VISIBLE
  "highlight MBEVisibleChanged term=bold cterm=bold gui=bold guibg=DarkRed guifg=Black
  map <leader>u :TMiniBufExplorer<cr>
  au BufRead,BufNew :call UMiniBufExplorer
"}}}1

"*** autocmd ***{{{1
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  au FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS

  "autocmd FileType python set ft=python.django " For SnipMate
  autocmd FileType html set ft=htmldjango.html " For SnipMate
  autocmd FileType xhtml set ft=htmldjango.html " For SnipMate

  autocmd FileType javascript call JavaScriptFold()
  autocmd FileType javascript setl nocindent

  autocmd FileType python set foldmethod=indent
  autocmd FileType coffee set foldmethod=indent

  autocmd! bufwritepost vimrc source ~/.vimrc
  "}}}1

"*** vimdiff ***{{{1
  if &diff
      map <Leader>gl :diffg 3<cr>
      map <Leader>gr :diffg 1<cr>
      map <Leader>uu :diffupdate<cr>
      let loaded_minibufexplorer = 1
  else
  endif
"}}}1

"*** git ***{{{1
  map <Leader>bl :call GitBlameLine()<CR>
"}}}1

" vim:ft=vim:fdm=marker
