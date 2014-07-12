global _start
section .text
open_printf:
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
  	call  0x26 
  	mov    esp,ebp
  	pop    ebp
  	ret    

close_printf:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x18
  	lea    eax,[ebp-0x8]
  	sub    esp,0xc
  	mov    BYTE[ebp-0x8],0x63
  	mov    BYTE[ebp-0x7],0x6c
  	mov    BYTE[ebp-0x6],0x6f
  	mov    BYTE[ebp-0x5],0x73
  	mov    BYTE[ebp-0x4],0xa
  	mov    BYTE[ebp-0x3],0x0
  	push   eax
  	call  0x56 
  	mov    esp,ebp
  	pop    ebp
  	ret    

__hook_dosFsOpen:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x8
  	call  0x67 
  	mov    esp,ebp
  	pop    ebp
  	ret    

__hook_dosFsClose:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x8
  	call  0x77 
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
  	call  0xa6 
  	mov    esp,ebp
  	pop    ebp
  	ret    

__hook_dosFsWrite:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x18
  	lea    eax,[ebp-0x8]
  	sub    esp,0xc
  	mov    BYTE[ebp-0x8],0x77
  	mov    BYTE[ebp-0x7],0x72
  	mov    BYTE[ebp-0x6],0x69
  	mov    BYTE[ebp-0x5],0x74
  	mov    BYTE[ebp-0x4],0xa
  	mov    BYTE[ebp-0x3],0x0
  	push   eax
  	call  0xd6 
  	mov    esp,ebp
  	pop    ebp
  	ret    

