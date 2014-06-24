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

read_ebp:
   	push   ebp
   	mov    ebp,esp
   	mov    eax,ebp
   	mov    esp,ebp
   	pop    ebp
   	ret    

pathcmp:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0xc
  	push   edi
  	xor    edi,edi
  	push   esi
  	mov    esi,DWORD[ebp+0xc]
  	push   ebx
  	mov    ebx,DWORD[ebp+0x8]
  	sub    esp,0xc
  	push   ebx
  	call   0x26 
  	add    esp,0x10
  	cmp    BYTE[eax+ebx*1-0x1],0x2f
  	je     0x62 
  	sub    esp,0xc
  	push   ebx
  	call   0x39 
  	add    esp,0x10
  	sub    esp,0xc
  	mov    BYTE[eax+ebx*1],0x2f
  	push   ebx
  	call   0x49 
  	mov    BYTE[eax+ebx*1+0x1],0x0
  	jmp    0x62 
  	lea    esi,[esi+0x0]
  	lea    edi,[edi+0x0]
  	inc    ebx
  	inc    esi
  	cmp    BYTE[ebx],0x0
  	je     0x75 
  	xor    edx,edx
  	mov    dl,BYTE[ebx]
  	xor    eax,eax
  	mov    al,BYTE[esi]
  	mov    edi,edx
  	sub    edi,eax
  	je     0x60 
  	test   edi,edi
  	jns    80 
  	or     eax,0xffffffff
  	jmp    0x92 
  	mov    esi,esi
  	cmp    edi,0x0
  	jle    90 
  	mov    eax,0x1
  	jmp    0x92 
  	lea    esi,[esi+0x0]
  	xor    eax,eax
  	lea    esp,[ebp-0x18]
  	pop    ebx
  	pop    esi
  	pop    edi
  	mov    esp,ebp
  	pop    ebp
  	ret    

traverse:
  	push   ebp
  	mov    ebp,esp
  	sub    esp,0x4ac
  	lea    eax,[ebp-0x49a]
  	mov    BYTE[ebp-0x4],0x25
  	push   edi
  	mov    edi,DWORD[ebp+0xc]
  	push   esi
  	mov    DWORD[ebp-0x4a4],eax
  	push   ebx
  	mov    ebx,DWORD[ebp+0x8]
  	mov    BYTE[ebp-0x3],0x73
  	mov    BYTE[ebp-0x2],0x0
  	mov    BYTE[ebp-0x49a],0x9
  	test   ebx,ebx
  	mov    BYTE[eax+0x1],0x0
  	mov    BYTE[ebp-0x8],0xd
  	mov    BYTE[ebp-0x7],0xa
  	mov    BYTE[ebp-0x6],0x0
  	je     0x1de 
  	lea    eax,[ebp-0x48]
  	lea    esi,[ebp-0x498]
  	mov    DWORD[ebp-0x4a0],eax
  	nop
  	lea    esi,[esi+0x0]
 	sub    esp,0x8
 	push   ebx
 	push   edi
 	call   0x106 
 	add    esp,0x10
 	test   eax,eax
 	je     0x126 
 	sub    esp,0x8
 	push   edi
 	push   ebx
 	call   0x117 
 	add    esp,0x10
 	test   eax,eax
 	jne    0x1d0 
 	sub    esp,0x4
 	mov    eax,DWORD[ebp-0x4a0]
 	push   0x40
 	push   0x0
 	push   eax
 	call   0x135 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x450
 	push   0x0
 	push   esi
 	call   0x148 
 	add    esp,0x10
 	mov    eax,DWORD[ebp+0x10]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	call   0x158 
 	add    esp,0x10
 	mov    eax,DWORD[ebp-0x4a4]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	call   0x16b 
 	add    esp,0x10
 	sub    esp,0x8
 	push   edi
 	push   esi
 	call   0x178 
 	add    esp,0x10
 	lea    eax,[ebp-0x49a]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	call   0x18b 
 	add    esp,0x10
 	mov    eax,DWORD[ebp-0x4a0]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	call   0x19e 
 	add    esp,0x10
 	lea    eax,[ebp-0x8]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	call   0x1ae 
 	add    esp,0x10
 	lea    eax,[ebp-0x4]
 	sub    esp,0x8
 	push   esi
 	push   eax
 	call   0x1be 
 	jmp    0x1de 
 	lea    esi,[esi+0x0]
 	lea    edi,[edi+0x0]
 	mov    ebx,DWORD[ebx+0x400]
 	test   ebx,ebx
 	jne    0x100 
 	lea    esp,[ebp-0x4b8]
 	pop    ebx
 	pop    esi
 	pop    edi
 	mov    esp,ebp
 	pop    ebp
 	ret    

__hook_dosFsOpen:
 	push   ebp
 	mov    ebp,esp
 	sub    esp,0x410
 	test   eax,eax
 	push   esi
 	push   ebx
 	jne    0x240 
 	sub    esp,0xc
 	push   0x1eb
 	call   0x22d 
 	jmp    0x289 
 	lea    esi,[esi+0x0]
 	lea    edi,[edi+0x0]
 	mov    esi,DWORD[eax+0x400]
 	test   esi,esi
 	je     0x289 
 	sub    esp,0x4
 	lea    ebx,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   ebx
 	call   0x25c 
 	add    esp,0x10
 	call   0x264 
 	sub    esp,0x8
 	mov    eax,DWORD[eax]
 	mov    edx,DWORD[eax+0x10]
 	push   edx
 	push   ebx
 	call   0x273 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x1fd
 	push   ebx
 	push   esi
 	call   0x285 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	mov    esp,ebp
 	pop    ebp
 	ret    

__hook_dosFsCreate:
 	push   ebp
 	mov    ebp,esp
 	sub    esp,0x410
 	test   eax,eax
 	push   esi
 	push   ebx
 	je     0x30d 
 	mov    esi,DWORD[eax+0x400]
 	test   esi,esi
 	je     0x30d 
 	sub    esp,0x4
 	lea    ebx,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   ebx
 	call   0x2e0 
 	add    esp,0x10
 	call   0x2e8 
 	sub    esp,0x8
 	mov    eax,DWORD[eax]
 	mov    edx,DWORD[eax+0x10]
 	push   edx
 	push   ebx
 	call   0x2f7 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x295
 	push   ebx
 	push   esi
 	call   0x309 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	mov    esp,ebp
 	pop    ebp
 	ret    

__hook_dosFsRead:
 	push   ebp
 	mov    ebp,esp
 	sub    esp,0x40c
 	test   eax,eax
 	push   edi
 	push   esi
 	push   ebx
 	je     0x3a7 
 	mov    edi,DWORD[eax+0x400]
 	test   edi,edi
 	je     0x3a7 
 	sub    esp,0x4
 	lea    esi,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   esi
 	call   0x361 
 	add    esp,0x10
 	call   0x369 
 	call   0x36e 
 	sub    esp,0xc
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	call   0x37a 
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	call   0x391 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x319
 	push   esi
 	push   edi
 	call   0x3a3 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	pop    edi
 	mov    esp,ebp
 	pop    ebp
 	ret    

__hook_dosFsWrite:
 	push   ebp
 	mov    ebp,esp
 	sub    esp,0x40c
 	test   eax,eax
 	push   edi
 	push   esi
 	push   ebx
 	je     0x447 
 	mov    edi,DWORD[eax+0x400]
 	test   edi,edi
 	je     0x447 
 	sub    esp,0x4
 	lea    esi,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   esi
 	call   0x401 
 	add    esp,0x10
 	call   0x409 
 	call   0x40e 
 	sub    esp,0xc
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	call   0x41a 
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	call   0x431 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x3b4
 	push   esi
 	push   edi
 	call   0x443 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	pop    edi
 	mov    esp,ebp
 	pop    ebp
 	ret    

__hook_dosFsClose:
 	push   ebp
 	mov    ebp,esp
 	sub    esp,0x40c
 	test   eax,eax
 	push   edi
 	push   esi
 	push   ebx
 	je     0x4e4 
 	mov    edi,DWORD[eax+0x400]
 	test   edi,edi
 	je     0x4e4 
 	sub    esp,0x4
 	lea    esi,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   esi
 	call   0x4a1 
 	add    esp,0x10
 	call   0x4a9 
 	sub    esp,0xc
 	mov    eax,DWORD[eax]
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	call   0x4b7 
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	call   0x4ce 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x454
 	push   esi
 	push   edi
 	call   0x4e0 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	pop    edi
 	mov    esp,ebp
 	pop    ebp
 	ret    

__hook_dosFsDelete:
 	push   ebp
 	mov    ebp,esp
 	sub    esp,0x410
 	test   eax,eax
 	push   esi
 	push   ebx
 	je     0x570 
 	mov    esi,DWORD[eax+0x400]
 	test   esi,esi
 	je     0x570 
 	sub    esp,0x4
 	lea    ebx,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   ebx
 	call   0x540 
 	add    esp,0x10
 	call   0x548 
 	call   0x54d 
 	sub    esp,0x8
 	mov    edx,DWORD[eax+0x8]
 	push   edx
 	push   ebx
 	call   0x55a 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x4f1
 	push   ebx
 	push   esi
 	call   0x56c 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	mov    esp,ebp
 	pop    ebp
 	ret    

