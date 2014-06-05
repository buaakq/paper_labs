
time.o:     file format elf32-i386


Disassembly of section .text:

00000000 <timestamp1>:
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 ec 18             	sub    esp,0x18
   6:	c6 45 f8 25          	mov    BYTE PTR [ebp-0x8],0x25
   a:	c6 45 f9 64          	mov    BYTE PTR [ebp-0x7],0x64
   e:	c6 45 fa 0a          	mov    BYTE PTR [ebp-0x6],0xa
  12:	c6 45 fb 00          	mov    BYTE PTR [ebp-0x5],0x0
  16:	e8 fc ff ff ff       	call   17 <timestamp1+0x17>
  1b:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
  1e:	83 ec 08             	sub    esp,0x8
  21:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
  24:	50                   	push   eax
  25:	8d 45 f8             	lea    eax,[ebp-0x8]
  28:	50                   	push   eax
  29:	e8 fc ff ff ff       	call   2a <timestamp1+0x2a>
  2e:	83 c4 10             	add    esp,0x10
  31:	89 ec                	mov    esp,ebp
  33:	5d                   	pop    ebp
  34:	c3                   	ret    
  35:	8d 74 26 00          	lea    esi,[esi+eiz*1+0x0]
  39:	8d bc 27 00 00 00 00 	lea    edi,[edi+eiz*1+0x0]

00000040 <timestamp2>:
  40:	55                   	push   ebp
  41:	89 e5                	mov    ebp,esp
  43:	83 ec 18             	sub    esp,0x18
  46:	c6 45 f8 25          	mov    BYTE PTR [ebp-0x8],0x25
  4a:	c6 45 f9 64          	mov    BYTE PTR [ebp-0x7],0x64
  4e:	c6 45 fa 0a          	mov    BYTE PTR [ebp-0x6],0xa
  52:	c6 45 fb 00          	mov    BYTE PTR [ebp-0x5],0x0
  56:	e8 fc ff ff ff       	call   57 <timestamp2+0x17>
  5b:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
  5e:	83 ec 08             	sub    esp,0x8
  61:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
  64:	50                   	push   eax
  65:	8d 45 f8             	lea    eax,[ebp-0x8]
  68:	50                   	push   eax
  69:	e8 fc ff ff ff       	call   6a <timestamp2+0x2a>
  6e:	83 c4 10             	add    esp,0x10
  71:	89 ec                	mov    esp,ebp
  73:	5d                   	pop    ebp
  74:	c3                   	ret    
