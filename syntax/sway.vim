if exists('b:current_syntax')
  finish
endif

syn keyword swayTodo TODO FIXME XXX BUG contained
syn match swayComment /^\s*#.*/ contains=@Spell,swayTodo

hi def link swayTodo Todo
hi def link swayComment Comment
hi def link swayVar var

let b:current_syntax = 'sway'
