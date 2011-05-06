" Name:    dynamicfoldcolumn.vim
" Version: 0.1.0
" Author:  Markus Braun <markus.braun@krawel.de>
" Summary: Vim plugin to show a dynamic number of foldcolumns
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
"
" Section: Documentation {{{1
"
" Description: {{{2
"
"   This plugin sets the number of foldcolumns depending on the width of the
"   window.
"
" Installation: {{{2
"
"   Copy the dynamicfoldcolumn.vim file to the $HOME/.vim/plugin directory.
"   Refer to ':help add-plugin', ':help add-global-plugin' and ':help
"   runtimepath' for more details about Vim plugins.
"
" Commands: {{{2
"
"   :DynamicFoldcolumnToggle
"      Toggle the display of foldcolumns
"
" Mappings: {{{2
"
"   <Leader>Dt     DynamicFoldcolumnToggle()
"
" Variables: {{{2
"
"   g:dynamicfoldcolumn_enabled
"     Enabled display of foldcolumns. Default 1.
"
"   g:dynamicfoldcolumn_minwidth
"     Windows wider than dynamicfoldcolumn_minwidth colums get foldcolumns.
"     Default 80.
"
"   g:dynamicfoldcolumn_switchwidth
"     For every dynamicfoldcolumn_switchwidth columns they get one additional
"     foldcolumn. Default 50.
"
"   g:dynamicfoldcolumn_mincolumns
"     If windows get foldcolumns they are at last dynamicfoldcolumn_mincolumns
"     wide. Default 2.
"
" Section: Plugin header {{{1

" guard against multiple loads {{{2
if (exists("g:loaded_dynamicfoldcolumn") || &cp)
  finish
endif
let g:loaded_dynamicfoldcolumn = 1

" check for correct vim version {{{2
if !has("folding")
  finish
endif

" define default "dynamicfoldcolumn_enabled" {{{2
if (!exists("g:dynamicfoldcolumn_enabled"))
  let g:dynamicfoldcolumn_enabled = 1
endif

" define default "dynamicfoldcolumn_minwidth" {{{2
if (!exists("g:dynamicfoldcolumn_minwidth"))
  let g:dynamicfoldcolumn_minwidth = 80
endif

" define default "dynamicfoldcolumn_switchwidth" {{{2
if (!exists("g:dynamicfoldcolumn_switchwidth"))
  let g:dynamicfoldcolumn_switchwidth = 50
endif

" define default "dynamicfoldcolumn_mincolumns" {{{2
if (!exists("g:dynamicfoldcolumn_mincolumns"))
  let g:dynamicfoldcolumn_mincolumns = 2
endif

" define default "dynamicfoldcolumn_debug" {{{2
if (!exists("g:dynamicfoldcolumn_debug"))
  let g:dynamicfoldcolumn_debug = 0
endif

" Section: Autocmd setup {{{1

if has("autocmd")
  augroup dynamicfoldcolumn
    autocmd!

    " call DynamicFoldcolumn() on every event that potentially changes the
    " width of a window
    autocmd VimEnter,BufWinEnter,WinEnter,VimResized * call <SID>DynamicFoldcolumn()
  augroup END
endif

" Section: Functions {{{1

" Function: s:DynamicFoldcolumnToggle() {{{2
"
" toggle the display of foldcolumns
"
function! s:DynamicFoldcolumnToggle()
  let g:dynamicfoldcolumn_enabled = (g:dynamicfoldcolumn_enabled + 1) % 2
  call s:DynamicFoldcolumn()
endfunction

" Function: s:DynamicFoldcolumn() {{{2
"
" calculate the number of foldcolumns and set it
"
function! s:DynamicFoldcolumn()
  let l:window = 1
  while l:window <= winnr("$")
    if winwidth(l:window) <= g:dynamicfoldcolumn_minwidth || g:dynamicfoldcolumn_enabled == 0
      let l:this_columns = 0
    else
      let l:this_columns = max( [ g:dynamicfoldcolumn_mincolumns, winwidth(l:window)/g:dynamicfoldcolumn_switchwidth ] )
    endif
    call s:DynamicFoldcolumnDebug(1,"DynamicFoldcolumn(): window " . l:window . " is " . winwidth(l:window) . " columns wide and gets " . l:this_columns . " foldcolumns")
    call setwinvar(l:window, "&foldcolumn", l:this_columns)
    let l:window += 1
  endwhile
endfunction

" Function: s:DynamicFoldcolumnDebug(level, text) {{{2
"
" output debug message, if this message has high enough importance
"
function! s:DynamicFoldcolumnDebug(level, text)
  if (g:dynamicfoldcolumn_debug >= a:level)
    echom "dynamicfoldcolumn: " . a:text
  endif
endfunction

" Section: Commands {{{1

command! DynamicFoldcolumnToggle call s:DynamicFoldcolumnToggle()

" Section: Mappings {{{1

" mapping to toggle DynamicFoldcolumn
map <Leader>ft :DynamicFoldcolumnToggle<CR>

" mappings to set foldlevel
map <Leader>f0 :silent! set foldlevel=0<CR>
map <Leader>f1 :silent! set foldlevel=1<CR>
map <Leader>f2 :silent! set foldlevel=2<CR>
map <Leader>f3 :silent! set foldlevel=3<CR>
map <Leader>f4 :silent! set foldlevel=4<CR>
map <Leader>f5 :silent! set foldlevel=5<CR>
map <Leader>f6 :silent! set foldlevel=6<CR>
map <Leader>f7 :silent! set foldlevel=7<CR>
map <Leader>f8 :silent! set foldlevel=8<CR>
map <Leader>f9 :silent! set foldlevel=9<CR>

" Section: Menu {{{1

if has("menu")
  amenu <silent> Plugin.DynamicFoldcolumn.Toggle :DynamicFoldcolumnToggle<CR>
endif

" vim600: foldmethod=marker foldlevel=0 :
