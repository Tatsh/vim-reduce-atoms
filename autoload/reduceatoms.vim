" autoload/reduceatoms.vim -- reduce Portage atoms to category/package.
" Maintainer: Andrew Udvare <audvare@gmail.com>
" License: MIT

let s:save_cpo = &cpoptions
set cpoptions&vim

" Atoms handed to qatom in batches so a 10k line package.use does not blow
" past ARG_MAX.
let s:batch_size = 1000

" Split a line into [indent, atom, remainder]. The remainder keeps its own
" leading whitespace so original spacing/alignment of USE flags survives.
" Returns an empty list for blank lines and comments.
function! s:Split(line) abort
  if a:line =~# '^\s*$' || a:line =~# '^\s*#'
    return []
  endif
  let l:m = matchlist(a:line, '^\(\s*\)\(\S\+\)\(.*\)$')
  return empty(l:m) ? [] : [l:m[1], l:m[2], l:m[3]]
endfunction

" Run qatom over a list of atoms, returning its raw output lines.
" Atoms are full of shell metacharacters (>=, !!<, *, [use]), so every one of
" them goes through shellescape(); system() in Vim takes a string command, the
" list form is Neovim only.
function! s:Qatom(atoms) abort
  let l:base = 'qatom -C -q -F ' . shellescape('%{CATEGORY} %{PN} %[SLOT]')
  let l:out = []
  let l:i = 0
  while l:i < len(a:atoms)
    let l:chunk = a:atoms[l:i : l:i + s:batch_size - 1]
    let l:cmd = l:base . ' ' . join(map(copy(l:chunk), 'shellescape(v:val)'))
    let l:out += systemlist(l:cmd)
    if v:shell_error
      throw 'reduce-atoms: qatom exited with ' . v:shell_error
    endif
    let l:i += s:batch_size
  endwhile
  return l:out
endfunction

" Turn one qatom output line into a reduced atom, or '' when it is unusable.
function! s:Reduced(out, keep_slot) abort
  let l:f = split(a:out)
  " qatom prints a literal <unset> category for anything it could not parse
  " as a qualified atom, so there is nothing safe to reduce.
  if len(l:f) < 2 || l:f[0] ==# '<unset>'
    return ''
  endif
  let l:atom = l:f[0] . '/' . l:f[1]
  if a:keep_slot && len(l:f) > 2
    let l:atom .= ':' . l:f[2]
  endif
  return l:atom
endfunction

" Reduce every atom in [line1, line2]. keep_slot preserves ':<slot>'.
function! reduceatoms#Reduce(line1, line2, keep_slot) abort
  if !executable('qatom')
    echohl ErrorMsg
    echomsg 'reduce-atoms: qatom not found (emerge app-portage/portage-utils)'
    echohl None
    return
  endif

  let l:lines = getline(a:line1, a:line2)
  " Parallel arrays: parts[n] belongs to buffer line lnums[n].
  let l:lnums = []
  let l:parts = []
  let l:atoms = []
  for l:i in range(len(l:lines))
    let l:p = s:Split(l:lines[l:i])
    if empty(l:p)
      continue
    endif
    call add(l:lnums, a:line1 + l:i)
    call add(l:parts, l:p)
    call add(l:atoms, l:p[1])
  endfor

  if empty(l:atoms)
    return
  endif

  try
    let l:out = s:Qatom(l:atoms)
  catch /^reduce-atoms:/
    echohl ErrorMsg
    echomsg v:exception
    echohl None
    return
  endtry

  if len(l:out) != len(l:atoms)
    echohl ErrorMsg
    echomsg printf('reduce-atoms: expected %d results from qatom, got %d',
          \ len(l:atoms), len(l:out))
    echohl None
    return
  endif

  let l:changed = 0
  let l:skipped = 0
  for l:i in range(len(l:atoms))
    let l:atom = s:Reduced(l:out[l:i], a:keep_slot)
    if empty(l:atom)
      let l:skipped += 1
      continue
    endif
    let l:new = l:parts[l:i][0] . l:atom . l:parts[l:i][2]
    if l:new !=# l:lines[l:lnums[l:i] - a:line1]
      call setline(l:lnums[l:i], l:new)
      let l:changed += 1
    endif
  endfor

  echomsg printf('reduce-atoms: %d line%s reduced%s', l:changed,
        \ l:changed == 1 ? '' : 's',
        \ l:skipped ? printf(', %d unparseable skipped', l:skipped) : '')
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
