global _start
section .text
_start:
   push ebp
   mov ebp,esp
   sub esp,8h
   call timestamp1
   push 3da776h
   ret

timestamp1:
push   ebp
mov    ebp,esp
sub    esp,0x18
mov   byte[ebp-0x8],0x25
mov   byte[ebp-0x7],0x64
mov   byte[ebp-0x6],0xa
mov   byte[ebp-0x5],0x0

mov    eax,30da80h
call   eax

mov   dword[ebp-0x4],eax
sub    esp,0x8
mov    eax,dword[ebp-0x4]
push   eax
lea    eax,[ebp-0x8]
push   eax

mov    eax,3be7b0h
call   eax

add    esp,0x10
mov    esp,ebp
pop    ebp
ret    

timestamp2:
push   ebp
mov    ebp,esp
sub    esp,0x18
mov  byte[ebp-0x8],0x25
mov  byte[ebp-0x7],0x64
mov  byte[ebp-0x6],0xa
mov  byte[ebp-0x5],0x0

mov    eax,30da80h
call   eax

mov   dword[ebp-0x4],eax
sub    esp,0x8
mov    eax,dword[ebp-0x4]
push   eax
lea   eax, [ebp-0x8]
push   eax

mov    eax, 3be7b0h
call   eax

add    esp,0x10
mov    esp,ebp
pop    ebp
ret    
