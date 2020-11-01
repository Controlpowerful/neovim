syntax on
set background=dark
set t_Co=256
set termguicolors
set number
set showcmd
set wrap
set wildmenu
set mouse=a
set encoding=UTF-8
set autoindent
set tabstop=4
set cursorline
set hlsearch
set incsearch
set ignorecase
set smartcase
let mapleader=" "
noremap <LEADER><CR> :nohlsearch<CR>

"  ________________
" < Plugin Install >
"  ----------------
"         \   ^__^
"          \  (oo)\_______
"             (__)\       )\/\
"                 ||----w |
"                 ||     ||
"
call plug#begin('~/.config/nvim/plugged')

" color theme and airline theme
Plug 'liuchengxu/space-vim-dark'
Plug 'hardcoreplayers/spaceline.vim'

" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode'

" Goyo
Plug 'junegunn/goyo.vim'

" vim-easy-align
Plug 'junegunn/vim-easy-align'

" coc
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" defx folder
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-icons'

" beautiful vim start plug
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'

call plug#end()

" coc.neovim
let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-clangd', 'coc-phpls', 'coc-python']

" spaceline
let g:spaceline_seperate_style = 'curve'
let g:spaceline_diagnostic_tool = 'coc'
let g:spaceline_diagnostic_errorsign = ''
let g:spaceline_diagnostic_warnsign = ''
let g:spaceline_git_branch_icon = '  '

" markdown-preview
map R :MarkdownPreview<CR>

" vim-table-mode
let g:table_mode_corner='|'
"let g:table_mode_corner_corner='+'
"let g:table_mode_header_fillchar='='

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

noremap <LEADER>tm :TableModeToggle<CR>
noremap <LEADER>tr :TableModeRealign<CR>

" vim-devicons
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" vim-defx
call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })
	
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> y
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> dd
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
endfunction

map D :Defx -columns=icons:indent:filename:type<CR>

" defx-icons
let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 1
let g:defx_icons_directory_icon = ''
let g:defx_icons_mark_icon = '*'
let g:defx_icons_copy_icon = ''
let g:defx_icons_move_icon = ''
let g:defx_icons_parent_icon = ''
let g:defx_icons_default_icon = ''
let g:defx_icons_directory_symlink_icon = ''

" Options below are applicable only when using "tree" feature
let g:defx_icons_root_opened_tree_icon = ''
let g:defx_icons_nested_opened_tree_icon = ''
let g:defx_icons_nested_closed_tree_icon = ''

hi default link DefxIconsMarkIcon Statement
hi default link DefxIconsCopyIcon WarningMsg
hi default link DefxIconsMoveIcon ErrorMsg
hi default link DefxIconsDirectory Directory
hi default link DefxIconsParentDirectory Directory
hi default link DefxIconsSymlinkDirectory Directory
hi default link DefxIconsOpenedTreeIcon Directory
hi default link DefxIconsNestedTreeIcon Directory
hi default link DefxIconsClosedTreeIcon Directory

" Goyo
 function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

noremap <LEADER>g :Goyo<CR>

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap al <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap al <Plug>(EasyAlign)




" color scheme
color space-vim-dark
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi Comment cterm=italic


" Keys
map q :q!<CR>
map s :w!<CR>
map S <C-v>
map H 5h
map L 5l
map J 5j
map K 5k
