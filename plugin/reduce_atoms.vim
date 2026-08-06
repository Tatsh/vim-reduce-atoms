" plugin/reduce_atoms.vim -- :ReduceAtoms command.
" Maintainer: Andrew Udvare <audvare@gmail.com>
" License: MIT
"
" :[range]ReduceAtoms   strip operator/version/slot/repo/use-deps from the
"                       atom at the start of each line, keeping the rest of
"                       the line (USE flags) untouched. With no range given
"                       it acts on the WHOLE buffer; pass an explicit range
"                       (:.  :5,10  :'<,'>) to narrow it.
" :[range]ReduceAtoms!  same, but keep the ':<slot>' restriction.
"
" Vim user commands must begin with an uppercase letter and contain only
" alphanumerics (:help E183), so ':reduce-atoms' is spelled ':ReduceAtoms'.

if exists('g:loaded_reduce_atoms') || &compatible || v:version < 800
  finish
endif
let g:loaded_reduce_atoms = 1

" -range=% : with no range the default is the entire buffer, so plain
" :ReduceAtoms needs no visual selection. An explicit range still wins.
command! -bar -bang -range=% ReduceAtoms
      \ call reduceatoms#Reduce(<line1>, <line2>, <bang>0)
