% 注入代码段调用实验
% 冯力 20140420

一. 目的：
====
1. 注入我们的代码段，代码段包含我们定义的函数，指令等。
2. 修改main函数的开头，跳转到注入的代码段，执行完后，再跳转回main函数继续执行。
3. 注入的代码段实现了调用test函数打印test输出。

二. 原理
=======
1. 替换函数开头指令。
------------------
为了不破坏elf的引用关系，减少工作量，最好的做法是替换掉函数开头的指令，而不是插入。因为插入的话需要修改elf的section headers table和program header table，更为严重的是可能破坏其它绝对地址的跳转和引用。

2. 增加一个proxy汇编调用层。
------------------------
由于替换了函数开头的指令，所以必须在被插入的代码里补上。如果插入和被插入的函数过多，那么相应的改动过大，所以最好的做法是加入一个中间层，结构如下：

```
main
|----->call proxy --->call real code---->return proxy --->return main
```

三. jmp和call的问题
==============

3.1. jmp指令的问题
------------
默认情况下，e9操作码（jmp）是跳转到相对地址。
所以需要使用其它指令来完成跳转。

```
push DESTINATION_VA
ret
```
例如：

```
push 0x80485bc\nret
\x68\xbc\x85\x04\x08\xc3
```
总共有6字节

或者

```
mov eax,DESTINATION_VA
jmp eax
```

例如

```
mov eax,0x80485bc\njmp eax
\xb8\xbc\x85\x04\x08\xff\xe0
总共有7字节
```

3.2. jmp 相对地址的计算方式如下：

```
jmp (DESTINATION_RVA - CURRENT_RVA - 5 [sizeof(E9 xx xx xx xx)])
```

call指令问题
-----------
默认情况下call指令同样是跳转到相对地址，可以采用的解决办法是：

	mov eax,0x804844c
	call eax

四. 工具介绍
=======
4.1. genshellcode.py
------------------
这个工具用来将instruction转换成可读字符串
可以使用-i直接传入指令，也可以使用-n 传入文件，格式为nasm汇编。

```
$ python genshellcode.py
usage: genshellcode.py [-h] [-n FILE] [-o OUTPUT] [-i INSTRUCTION] [-a ARCH]

optional arguments:
  -h, --help      show this help message and exit
  -n FILE         nasm or object file
  -o OUTPUT       output file
  -i INSTRUCTION  instruction
  -a ARCH         architecture [elf/elf64]
```

4.2. hook.py
----------
这个工具进行elf的修改操作。最重要的参数有两个，一个是-s，传入注入到elf代码段的shellcode码，另一个是-i，传入注入到main函数开头的shellcode码。

```
$ python hook.py                                                                  1 ↵
Usage: hook.py [options]

inject

Options:
  -h, --help            show this help message and exit
  -f FILE, --file=FILE  File to patch
  -t OBJECT_FILE, --object_file=OBJECT_FILE
                        Get text section and  add it to out file
  -s SHELLCODE, --shellcode=SHELLCODE
                        User supplied shellcode, place it in text section,make
                        sure that it matches the architecture that you are
                        targeting.
  -i INJECT_INS, --inject_ins=INJECT_INS
                        inject instruction into functions prolog
  -o OUTPUT, --output-file=OUTPUT
                        The backdoor output file
  -n NSECTION, --section=NSECTION
                        New section name must be less than seven characters
  -v, --verbose         For debug information output.
```

五. 开始patch
=========

5.1. 跳转到我们注入的代码段，并跳回，程序正常运行。

```
$ cat test/inject.nasm                                                            1 ↵
global _start
section .text
_start:
    push ebp
    mov ebp,esp
    and esp,0xfffffff0
    push 0x8048466
    ret
$ python genshellcode.py -n test/inject.nasm                               1 ↵
[+] Encoded:
\x55\x89\xe5\x83\xe4\xf0\x68\x66\x84\x04\x08\xc3

$ python genshellcode.py -i 'push 0x80485bc\nret'                                 1 ↵
[+] Encoded:
\x68\xbc\x85\x04\x08\xc3

$ python hook.py -f test/main -s  '\x55\x89\xe5\x83\xe4\xf0\x68\x66\x84\x04\x08\xc3' -i '\x68\xbc\x85\x04\x08\xc3'
[*] Gathering file info
[*] Patching Binary
[!] Patching Complete
[+] Patched File: test/main.patched
[+] Patched inject_point: 0x80485bc file Offset: 0x5bc
[+] main :0x8048460 file offset: 0x460
[+] inject prolog:
\x55\x89\xe5\x83\xe4\xf0
\x68\xbc\x85\x4\x8\xc3
write:\x55\x89\xe5\x83\xe4\xf0->\x68\xbc\x85\x4\x8\xc3

$ ./test/main.patched.1
1
```

5.2. 跳转到我们注入的代码，我们的代码里面调用一下test函数打印test输出。

```
$ python genshellcode.py -n test/inject.nasm
[+] Encoded:
\x55\x89\xe5\x83\xe4\xf0\xb8\x4c\x84\x04\x08\xff\xd0\x68\x66\x84\x04\x08\xc3

$ cat test/inject.nasm                                                            2 ↵
global _start
section .text
_start:
    push ebp
    mov ebp,esp
    and esp,0xfffffff0
    mov eax,0x804844c
    call eax
    push 0x8048466
    ret

$ python hook.py -f test/main -s  '\x55\x89\xe5\x83\xe4\xf0\xb8\x4c\x84\x04\x08\xff\xd0\x68\x66\x84\x04\x08\xc3' -i '\x68\xbc\x85\x04\x08\xc3'
[*] Gathering file info
[*] Patching Binary
[!] Patching Complete
[+] Patched File: test/main.patched
[+] Patched inject_point: 0x80485bc file Offset: 0x5bc
[+] main :0x8048460 file offset: 0x460
[+] inject prolog:
\x55\x89\xe5\x83\xe4\xf0
\x68\xbc\x85\x4\x8\xc3
write:\x55\x89\xe5\x83\xe4\xf0->\x68\xbc\x85\x4\x8\xc3

$ ./test/main.patched.1
test1
```

六. 尚未完成的任务
================

1. 完善工具，以便将o文件直接全部注入到elf里，同时修正引用关系，替换掉字符串等对其它非text节的依赖。

2. 完成移动函数开头足够的字节数到我们的proxy汇编里。

附：修改的elf文件的c源码
========================

```
$ cat test/main.c
#include <stdio.h>

void test() {
  printf("test");
}
void main() {
  printf("1\n");
}
```
