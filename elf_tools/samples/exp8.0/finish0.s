
hookFs_finish.o:     file format elf32-i386


Disassembly of section .text:

00000000 <open_printf>:
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 ec 18             	sub    esp,0x18
   6:	8d 45 f8             	lea    eax,[ebp-0x8]
   9:	83 ec 0c             	sub    esp,0xc
   c:	c6 45 f8 6f          	mov    BYTE PTR [ebp-0x8],0x6f
  10:	c6 45 f9 70          	mov    BYTE PTR [ebp-0x7],0x70
  14:	c6 45 fa 65          	mov    BYTE PTR [ebp-0x6],0x65
  18:	c6 45 fb 6e          	mov    BYTE PTR [ebp-0x5],0x6e
  1c:	c6 45 fc 0a          	mov    BYTE PTR [ebp-0x4],0xa
  20:	c6 45 fd 00          	mov    BYTE PTR [ebp-0x3],0x0
  24:	50                   	push   eax
  25:	e8 fc ff ff ff       	call   26 <open_printf+0x26>
  2a:	89 ec                	mov    esp,ebp
  2c:	5d                   	pop    ebp
  2d:	c3                   	ret    
  2e:	89 f6                	mov    esi,esi

00000030 <close_printf>:
  30:	55                   	push   ebp
  31:	89 e5                	mov    ebp,esp
  33:	83 ec 18             	sub    esp,0x18
  36:	8d 45 f8             	lea    eax,[ebp-0x8]
  39:	83 ec 0c             	sub    esp,0xc
  3c:	c6 45 f8 63          	mov    BYTE PTR [ebp-0x8],0x63
  40:	c6 45 f9 6c          	mov    BYTE PTR [ebp-0x7],0x6c
  44:	c6 45 fa 6f          	mov    BYTE PTR [ebp-0x6],0x6f
  48:	c6 45 fb 73          	mov    BYTE PTR [ebp-0x5],0x73
  4c:	c6 45 fc 0a          	mov    BYTE PTR [ebp-0x4],0xa
  50:	c6 45 fd 00          	mov    BYTE PTR [ebp-0x3],0x0
  54:	50                   	push   eax
  55:	e8 fc ff ff ff       	call   56 <close_printf+0x26>
  5a:	89 ec                	mov    esp,ebp
  5c:	5d                   	pop    ebp
  5d:	c3                   	ret    
  5e:	89 f6                	mov    esi,esi

00000060 <__hook_dosFsOpen>:
  60:	55                   	push   ebp
  61:	89 e5                	mov    ebp,esp
  63:	83 ec 08             	sub    esp,0x8
  66:	e8 fc ff ff ff       	call   67 <__hook_dosFsOpen+0x7>
  6b:	89 ec                	mov    esp,ebp
  6d:	5d                   	pop    ebp
  6e:	c3                   	ret    
  6f:	90                   	nop

00000070 <__hook_dosFsClose>:
  70:	55                   	push   ebp
  71:	89 e5                	mov    ebp,esp
  73:	83 ec 08             	sub    esp,0x8
  76:	e8 fc ff ff ff       	call   77 <__hook_dosFsClose+0x7>
  7b:	89 ec                	mov    esp,ebp
  7d:	5d                   	pop    ebp
  7e:	c3                   	ret    
  7f:	90                   	nop

00000080 <__hook_dosFsRead>:
  80:	55                   	push   ebp
  81:	89 e5                	mov    ebp,esp
  83:	83 ec 18             	sub    esp,0x18
  86:	8d 45 f8             	lea    eax,[ebp-0x8]
  89:	83 ec 0c             	sub    esp,0xc
  8c:	c6 45 f8 72          	mov    BYTE PTR [ebp-0x8],0x72
  90:	c6 45 f9 65          	mov    BYTE PTR [ebp-0x7],0x65
  94:	c6 45 fa 61          	mov    BYTE PTR [ebp-0x6],0x61
  98:	c6 45 fb 64          	mov    BYTE PTR [ebp-0x5],0x64
  9c:	c6 45 fc 0a          	mov    BYTE PTR [ebp-0x4],0xa
  a0:	c6 45 fd 00          	mov    BYTE PTR [ebp-0x3],0x0
  a4:	50                   	push   eax
  a5:	e8 fc ff ff ff       	call   a6 <__hook_dosFsRead+0x26>
  aa:	89 ec                	mov    esp,ebp
  ac:	5d                   	pop    ebp
  ad:	c3                   	ret    
  ae:	89 f6                	mov    esi,esi

000000b0 <__hook_dosFsWrite>:
  b0:	55                   	push   ebp
  b1:	89 e5                	mov    ebp,esp
  b3:	83 ec 18             	sub    esp,0x18
  b6:	8d 45 f8             	lea    eax,[ebp-0x8]
  b9:	83 ec 0c             	sub    esp,0xc
  bc:	c6 45 f8 77          	mov    BYTE PTR [ebp-0x8],0x77
  c0:	c6 45 f9 72          	mov    BYTE PTR [ebp-0x7],0x72
  c4:	c6 45 fa 69          	mov    BYTE PTR [ebp-0x6],0x69
  c8:	c6 45 fb 74          	mov    BYTE PTR [ebp-0x5],0x74
  cc:	c6 45 fc 0a          	mov    BYTE PTR [ebp-0x4],0xa
  d0:	c6 45 fd 00          	mov    BYTE PTR [ebp-0x3],0x0
  d4:	50                   	push   eax
  d5:	e8 fc ff ff ff       	call   d6 <__hook_dosFsWrite+0x26>
  da:	89 ec                	mov    esp,ebp
  dc:	5d                   	pop    ebp
  dd:	c3                   	ret    
