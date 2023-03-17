if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal indentexpr=SwayIndent()
setlocal indentkeys=0{,0},!^F,o,O,e
setlocal nosmartindent

let b:undo_indent = 'setlocal indentexpr< indentkeys< smartindent<'

if exists('*SwayIndent')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

function! SwayIndent()
  let prevlnum = prevnonblank(v:lnum - 1)
  if prevlnum == 0
    return 0
  endif

  let prevprevlnum = prevnonblank(prevlnum - 1)

  let prevprevline = getline(prevprevlnum)
  let prevline = getline(prevlnum)
  let curline = getline(v:lnum)

  let indent = indent(prevlnum)

  " If the previous line ends in a {, increase the indent level.
  if prevline !~# '^\s*#' && prevline =~# '{\s*$'
    let indent += &shiftwidth
  endif

  " If the current line ends in a }, decrease the indent level.
  if curline =~# '^\s*}'
    let indent -= &shiftwidth
  endif

  " If the previous line is the first continuation line, increase the indent level.
  " If the previous line is the first non-continuation line, decrease the indent level.
  if s:is_continuation(prevline)
    if !s:is_continuation(prevprevline)
      let indent += &shiftwidth
    endif
  else
    if s:is_continuation(prevprevline)
      let indent -= &shiftwidth
    endif
  endif

  return indent
endfunction

function s:is_continuation(line)
  return a:line !~# '^\s*#' && a:line =~# '\\\s*$'
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
