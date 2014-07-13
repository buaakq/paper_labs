global _start
section .text
read_ebp:
   	push   ebp
   	mov    ebp,esp
   	mov    eax,ebp
   	mov    esp,ebp
   	pop    ebp
   	ret    

__hook_dosFsOpen:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x18
  	lea    eax,[ebp-0x8]
  	sub    esp,0xc
  	mov    BYTE[ebp-0x8],0x6f
  	mov    BYTE[ebp-0x7],0x70
  	mov    BYTE[ebp-0x6],0x65
  	mov    BYTE[ebp-0x5],0x6e
  	mov    BYTE[ebp-0x4],0xa
  	mov    BYTE[ebp-0x3],0x0
  	push   eax
  	 call -0x5163c
  	mov    esp,ebp
  	pop    ebp
  	ret    

__hook_dosFsRead:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x18
  	lea    eax,[ebp-0x8]
  	sub    esp,0xc
  	mov    BYTE[ebp-0x8],0x72
  	mov    BYTE[ebp-0x7],0x65
  	mov    BYTE[ebp-0x6],0x61
  	mov    BYTE[ebp-0x5],0x64
  	mov    BYTE[ebp-0x4],0xa
  	mov    BYTE[ebp-0x3],0x0
  	push   eax
  	 call -0x5166c
  	mov    esp,ebp
  	pop    ebp
  	ret    

hook_dosFsOpen:
  push ebp
  mov ebp,esp
  sub esp,1ch

  call __hook_dosFsOpen

  push 3739f6h
  ret 



hook_dosFsRead:
  push ebp
  mov ebp,esp
  sub esp,14h

  call __hook_dosFsRead

  push 374b46h
  ret 

