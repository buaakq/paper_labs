global _start
section .text

hook_usrAppInit:
  push ebp
  mov ebp,esp
  sub esp,18h

  call init_hookFs

  push 314606h
  ret

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


hook_dosFsCreate:
  push ebp
  mov ebp,esp
  sub esp,10h

  call __hook_dosFsCreate

  push 373db6h
  ret 


hook_dosFsDelete:
  push ebp
  mov ebp,esp
  sub esp,0ch

  call __hook_dosFsDelete

  push 3741b6h
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

init_hookFs:
   	push   ebp
   	mov    ebp,esp
   	sub    esp,0x14
   	push   ebx
   	sub    esp,0xc
   	push   0x404
   	 call 0x351e6
  	add    esp,0x10
  	mov    ebx,eax
  	sub    esp,0xc
  	push   0x404
  	 call 0x351d4
  	add    esp,0x10
  	sub    esp,0x8
  	mov    DWORD[eax+0x400],ebx
  	lea    eax,[ebp-0x2]
  	mov    BYTE[ebp-0x2],0x2f
  	mov    BYTE[eax+0x1],0x0
  	push   eax
  	push   ebx
  	 call 0x2b1d1
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
  	 call 0x2b340
  	add    esp,0x10
  	cmp    BYTE[eax+ebx*1-0x1],0x2f
  	je     0xc2 
  	sub    esp,0xc
  	push   ebx
  	 call 0x2b32d
  	add    esp,0x10
  	sub    esp,0xc
  	mov    BYTE[eax+ebx*1],0x2f
  	push   ebx
  	 call 0x2b31d
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
 	 call 0x2af20
 	add    esp,0x10
 	test   eax,eax
 	je     0x186 
 	sub    esp,0x8
 	push   edi
 	push   ebx
 	

        call pathcmp 


 	add    esp,0x10
 	test   eax,eax
 	jne    0x230 
 	sub    esp,0x4
 	mov    eax,DWORD[ebp-0x4a0]
 	push   0x40
 	push   0x0
 	push   eax
 	 call 0x2ae51
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x450
 	push   0x0
 	push   esi
 	 call 0x2ae3e
 	add    esp,0x10
 	mov    eax,DWORD[ebp+0x10]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	 call 0x2b05e
 	add    esp,0x10
 	mov    eax,DWORD[ebp-0x4a4]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	 call 0x2ae4b
 	add    esp,0x10
 	sub    esp,0x8
 	push   edi
 	push   esi
 	 call 0x2ae3e
 	add    esp,0x10
 	lea    eax,[ebp-0x49a]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	 call 0x2ae2b
 	add    esp,0x10
 	mov    eax,DWORD[ebp-0x4a0]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	 call 0x2ae18
 	add    esp,0x10
 	lea    eax,[ebp-0x8]
 	sub    esp,0x8
 	push   eax
 	push   esi
 	 call 0x2ae08
 	add    esp,0x10
 	lea    eax,[ebp-0x4]
 	sub    esp,0x8
 	push   esi
 	push   eax
 	 call 0x2e7d8
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
 	 call 0x2e769
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
 	 call 0x2ad2a
 	add    esp,0x10
 	
        call   read_ebp 
 	
        sub    esp,0x8
 	mov    eax,DWORD[eax]
 	mov    edx,DWORD[eax+0x10]
 	push   edx
 	push   ebx
 	 call 0x2af43
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x25d
 	push   ebx
 	push   esi
 	
call   traverse 

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
 	  call 0x2aca6
 	add    esp,0x10
 	
call  read_ebp 
 	sub    esp,0x8
 	mov    eax,DWORD[eax]
 	mov    edx,DWORD[eax+0x10]
 	push   edx
 	push   ebx
 	 call 0x2aebf
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x2f5
 	push   ebx
 	push   esi
 	
call   traverse
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
 	 call 0x2ac25
 	add    esp,0x10
 	
call   read_ebp 

 	
call   read_ebp

 	sub    esp,0xc
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	 call 0x1463c
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	 call 0x2ae25
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x379
 	push   esi
 	push   edi
 	
call   traverse

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
 	 call 0x2ab85
 	add    esp,0x10
 	
call   read_ebp 

 	
call   read_ebp

 	sub    esp,0xc
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	 call 0x1459c
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	 call 0x2ad85
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x414
 	push   esi
 	push   edi
 	
call   traverse
 
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
 	 call 0x2aae5
 	add    esp,0x10
 	
call   read_ebp
 
 	sub    esp,0xc
 	mov    eax,DWORD[eax]
 	mov    ebx,DWORD[eax+0x8]
 	push   ebx
 	 call 0x144ff
 	mov    eax,DWORD[ebx]
 	add    esp,0x10
 	sub    esp,0x8
 	mov    eax,DWORD[eax+0x78]
 	add    eax,0xf0
 	push   eax
 	push   esi
 	 call 0x2ace8
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x4b4
 	push   esi
 	push   edi
 	 
call traverse
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
 	  call 0x2aa46
 	add    esp,0x10
 
	
call   read_ebp 
call   read_ebp

 	sub    esp,0x8
 	mov    edx,DWORD[eax+0x8]
 	push   edx
 	push   ebx
 	 call 0x2ac5c
 	add    esp,0x10
 	sub    esp,0x4
 	push   0x551
 	push   ebx
 	push   esi
 	
call   traverse 

 	lea    esp,[ebp-0x418]
 	pop    ebx
 	pop    esi
 	mov    esp,ebp
 	pop    ebp
 	ret    

