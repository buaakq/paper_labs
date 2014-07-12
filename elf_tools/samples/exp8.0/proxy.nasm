
hook_dosFsOpen:
  push ebp
  mov ebp,esp
  sub esp,1ch

  call __hook_dosFsOpen

  push 3739f6h
  ret 

hook_dosFsClose:
  push ebp
  mov ebp,esp
  sub esp,1ch

  call __hook_dosFsClose

  push 373e56h
  ret 

hook_dosFsRead:
  push ebp
  mov ebp,esp
  sub esp,14h

  call __hook_dosFsRead

  push 374b46h
  ret 


hook_dosFsWrite:
  push ebp
  mov ebp,esp
  sub esp,14h

  call __hook_dosFsWrite

  push 374bb6h
  ret 

