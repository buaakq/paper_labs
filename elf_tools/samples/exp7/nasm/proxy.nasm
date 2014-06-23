global_start
section .text

hook_dosFsOpen:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call __hook_dosFsOpen

  push xxxxxxh
  ret 

hook_dosFsClose:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call __hook_dosFsClose

  push xxxxxxh
  ret 


hook_dosFsCreate:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call __hook_dosFsCreate

  push xxxxxxh
  ret 


hook_dosFsDelete:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call __hook_dosFsDelete

  push xxxxxxh
  ret 


hook_dosFsRead:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call __hook_dosFsRead

  push xxxxxxh
  ret 


hook_dosFsWrite:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call __hook_dosFsWrite

  push xxxxxxh
  ret 

