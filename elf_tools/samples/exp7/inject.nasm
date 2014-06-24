global_start
section .text

hook_usrAppInit:
  push ebp
  mov ebp,esp
  sub esp,xxh

  call init_hookFs

  push xxxxxxxxxh
  ret

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

init_hookFs:
   	push   ebp
   	mov    ebp,esp
   	sub    esp,0x14
   	push   ebx
   	sub    esp,0xc
   	push   0x404
   	
	call malloc
	;call   0x10 
  	
	add    esp,0x10
  	mov    ebx,eax
  	sub    esp,0xc
  	push   0x404
  	
	;call   0x22 
  	call malloc

	add    esp,0x10
  	sub    esp,0x8
  	mov    DWORD[eax+0x400],ebx
  	lea    eax,[ebp-0x2]
  	mov    BYTE[ebp-0x2],0x2f
  	mov    BYTE[eax+0x1],0x0
  	push   eax
  	push   ebx
  	
	;call   0x45
	call strcpy
  	
	mov    DWORD[ebx+0x400],0x0
  	mov    eax,0x1
  	mov    ebx,DWORD[ebp-0x18]
  	mov    esp,ebp
  	pop    ebp
  	ret    

read_ebp:
  	push   ebp
  	mov    ebp,esp
  	mov    eax,ebp
  	mov    esp,ebp
  	pop    ebpjjj
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
  	
	call strlen
	;call   0x86 
  	
	add    esp,0x10
  	cmp    BYTE[eax+ebx*1-0x1],0x2f
  	je     0xc2 
  	sub    esp,0xc
  	push   ebx
  	
	;call   0x99 
  	call strlen

	add    esp,0x10
  	sub    esp,0xc
  	mov    BYTE[eax+ebx*1],0x2f
  	push   ebx
  	
	;call   0xa9 
  	call strlen

	mov    BYTE[eax+ebx*1+0x1],0x0
  	jmp    0xc2 
  	lea    esi,[esi+0x0]
  	lea    edi,[edi+0x0]
  	inc    ebx
  	inc    esi
  	cmp    BYTE[ebx],0x0
  	je     0xd5 
  	xor    edx,edx
  	mov    dl,BYTE[ebx]
  	xor    eax,eax
  	mov    al,BYTE[esi]
  	mov    edi,edx
  	sub    edi,eax
  	je     0xc0 
  	test   edi,edi
  	jns    0xe0 
  	or     eax,0xffffffff
  	jmp    0xf2 
  	mov    esi,esi
  	cmp    edi,0x0
  	jle    0xf0 
  	mov    eax,0x1
  	jmp    0xf2 
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
 	je     0x23e 
 	lea    eax,[ebp-0x48]
 	lea    esi,[ebp-0x498]
 	mov    DWORD[ebp-0x4a0],eax
 	nop
 	lea    esi,[esi+0x0]
 	sub    esp,0x8
 	push   ebx
 	push   edi
 	
	;call   0x166 
 	call strcmp

	add    esp,0x10
 	test   eax,eax
 	je     0x186 
 	sub    esp,0x8
 	push   edi
 	push   ebx
 	
	;call   0x177 
 	call pathcmp

	add    esp,0x10
 	test   eax,eax
 	jne    0x230 
 	sub    esp,0x4
 	mov    eax,DWORD[ebp-0x4a0]
 	push   0x40
 	push   0x0
 	push   eax
 	
	;call   0x195 
 	call memset

	add    esp,0x10
 	sub    esp,0x4
 	push   0x450
 	push   0x0
 	push   esi
 	
	;call   0x1a8 
 	call memset

	add    esp,0x10
 	mov    eax,DWORD[ebp+0x10]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	
	;call   0x1b8 
 	call strcpy

	add    esp,0x10
 	mov    eax,DWORD[ebp-0x4a4]
 	sub    esp,0x8
 	push   eax
 	push   esi
        
	call strcat
 	;call   0x1cb 
 	
	add    esp,0x10
 	sub    esp,0x8
 	push   edi
 	push   esi

 	;call   0x1d8 
 	call strcat 

	add    esp,0x10
 	lea    eax,[ebp-0x49a]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	
	;call   0x1eb 
 	call strcat

	add    esp,0x10
 	mov    eax,DWORD[ebp-0x4a0]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	
	;call   0x1fe 
 	call strcat

	add    esp,0x10
 	lea    eax,[ebp-0x8]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	
	;call   0x20e 
 	call strcat

	add    esp,0x10
 	lea    eax,[ebp-0x4]
 	sub    esp,0x8
 	push   esi
 	push   eax
 	
	call printf
	;call   0x21e 
 	
	jmp    0x23e 
 	lea    esi,[esi+0x0]
 	lea    edi,[edi+0x0]
 	mov    ebx,DWORD[ebx+0x400]
 	test   ebx,ebx
 	jne    0x160 
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
 	jne    0x2a0 
 	sub    esp,0xc
 	push   0x24b

	
 	;call   0x28d 
 	
	jmp    0x2e9 
 	lea    esi,[esi+0x0]
 	lea    edi,[edi+0x0]
 	mov    esi,DWORD[eax+0x400]
 	test   esi,esi
 	je     0x2e9 
 	sub    esp,0x4
 	lea    ebx,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   ebx
 	call   0x2bc 
 	add    esp,0x10
 	call   0x2c4 
 	sub    esp,0x8
 	mov    eax,DWORD[eax]
 	mov    edx,DWORD[eax+0x10]
 	push   edx
 	push   ebx
 	call   0x2d3 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x25d
 	push   ebx
 	push   esi
 	call   0x2e5 
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
 	je     0x36d 
 	mov    esi,DWORD[eax+0x400]
 	test   esi,esi
 	je     0x36d 
 	sub    esp,0x4
 	lea    ebx,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   ebx
 	call   0x340 
 	add    esp,0x10
 	call   0x348 
 	sub    esp,0x8
 	mov    eax,DWORD[eax]
 	mov    edx,DWORD[eax+0x10]
 	push   edx
 	push   ebx
 	call   0x357 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x2f5
 	push   ebx
 	push   esi
 	call   0x369 
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
 	je     0x407 
 	mov    edi,DWORD[eax+0x400]
 	test   edi,edi
 	je     0x407 
 	sub    esp,0x4
 	lea    esi,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   esi
 	call   0x3c1 
 	add    esp,0x10
 	call   0x3c9 
 	call   0x3ce 
 	sub    esp,0xc
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	call   0x3da 
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	call   0x3f1 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x379
 	push   esi
 	push   edi
 	call   0x403 
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
 	je     0x4a7 
 	mov    edi,DWORD[eax+0x400]
 	test   edi,edi
 	je     0x4a7 
 	sub    esp,0x4
 	lea    esi,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   esi
 	call   0x461 
 	add    esp,0x10
 	call   0x469 
 	call   0x46e 
 	sub    esp,0xc
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	call   0x47a 
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	call   0x491 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x414
 	push   esi
 	push   edi
 	call   0x4a3 
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
 	je     0x544 
 	mov    edi,DWORD[eax+0x400]
 	test   edi,edi
 	je     0x544 
 	sub    esp,0x4
 	lea    esi,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   esi
 	call   0x501 
 	add    esp,0x10
 	call   0x509 
 	sub    esp,0xc
 	mov    eax,DWORD[eax]
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	call   0x517 
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	call   0x52e 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x4b4
 	push   esi
 	push   edi
 	call   0x540 
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
 	je     0x5d0 
 	mov    esi,DWORD[eax+0x400]
 	test   esi,esi
 	je     0x5d0 
 	sub    esp,0x4
 	lea    ebx,[ebp-0x400]
 	push   0x400
 	push   0x0
 	push   ebx
 	call   0x5a0 
 	add    esp,0x10
 	call   0x5a8 
 	call   0x5ad 
 	sub    esp,0x8
 	mov    edx,DWORD[eax+0x8]
 	push   edx
 	push   ebx
 	call   0x5ba 
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x551
 	push   ebx
 	push   esi
 	call   0x5cc 
 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	mov    esp,ebp
 	pop    ebp
 	ret    

