" Name: dynamicfoldcolumn.vim
" Version: $Id$
" Author: Markus Braun
" Summary: Vim plugin dynamic number of foldcolumns
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
" Section: Documentation {{{1
"
" Description:
"
"   This plugin sets the number of foldcolumns depending on the width of the
"   window.
"
" Installation:
"
"   Copy the dynamicfoldcolumn.vim file to the $HOME/.vim/plugin directory.
"   Refer to ':help add-plugin', ':help add-global-plugin' and ':help
"   runtimepath' for more details about Vim plugins.
"
" Commands:
"
"   :DynamicFoldcolumnToggle
"      Toggle the display of foldcolumns
"
" Mappings:
"
"   <Leader>Dt     DynamicFoldcolumnToggle()
"
" Variables:
"
"   g:DynamicFoldcolumnsEnabled
"     Enabled display of foldcolumns. Default 1.
"
"   g:DynamicFoldcolumnsMinWidth
"     Windows wider than DynamicFoldcolumnsMinWidth colums get foldcolumns.
"     Default 80.
"
"   g:DynamicFoldcolumnsSwitchWidth
"     For every DynamicFoldcolumnsSwitchWidth columns they get one additional
"     foldcolumn. Default 50.
"
"   g:DynamicFoldcolumnsMinColumns
"     If windows get foldcolumns they are at last DynamicFoldcolumnsMinColumns
"     wide. Default 2.
"
" Section: Plugin header {{{1

if (exists("g:loaded_dynamicfoldcolumns") || &cp)
  finish
endif
if !has("folding")
  finish
endif
let g:loaded_dynamicfoldcolumns = "$Revision$"

if (!exists("g:DynamicFoldcolumnsEnabled"))
  let g:DynamicFoldcolumnsEnabled = 1
endif

if (!exists("g:DynamicFoldcolumnsMinWidth"))
  let g:DynamicFoldcolumnsMinWidth = 80
endif

if (!exists("g:DynamicFoldcolumnsSwitchWidth"))
  let g:DynamicFoldcolumnsSwitchWidth = 50
endif

if (!exists("g:DynamicFoldcolumnsMinColumns"))
  let g:DynamicFoldcolumnsMinColumns = 2
endif

" Section: Autocmd setup {{{1
" call DynamicFoldcolumn() on every event that potentially changes the width
" of a window
autocmd VimEnter,BufWinEnter,WinEnter,VimResized * call <SID>DynamicFoldcolumn()

" Section: Functions {{{1
" Function: s:DynamicFoldcolumnToggle() {{{2
"
" toggle the display of foldcolumns
function! s:DynamicFoldcolumnToggle()
  let g:DynamicFoldcolumnsEnabled = (g:DynamicFoldcolumnsEnabled + 1) % 2
  call s:DynamicFoldcolumn()
endfunction

" Function: s:DynamicFoldcolumn() {{{2
"
" calculate the number of foldcolumns and set it
function! s:DynamicFoldcolumn()
  let l:window = 1
  while l:window <= winnr("$")
    if winwidth(l:window) <= g:DynamicFoldcolumnsMinWidth || g:DynamicFoldcolumnsEnabled == 0
      let l:this_columns = 0
    else
      let l:this_columns = max( [ g:DynamicFoldcolumnsMinColumns, winwidth(l:window)/g:DynamicFoldcolumnsSwitchWidth ] )
    endif
    "echom "DynamicFoldcolumn(): window " . l:window . " is " . winwidth(l:window) . " columns wide and gets " . l:this_columns . " foldcolumns"
    call setwinvar(l:window, "&foldcolumn", l:this_columns)
    let l:window += 1
  endwhile
endfunction

" Section: Commands {{{1
command! DynamicFoldcolumnToggle call s:DynamicFoldcolumnToggle()

" Section: Mappings {{{1
" mapping to toggle DynamicFoldcolumn
map <Leader>Dt :DynamicFoldcolumnToggle<CR>

" vim600:fdm=marker:commentstring="\ %s:
