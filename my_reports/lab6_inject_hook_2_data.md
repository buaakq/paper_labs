#注入hookFsOpen到vxworks的实验

##〇、概述

- 目的：证明可以注入hook函数到vxworks中，并劫持open函数
- 注入位置：注入到了data节中，地址是3d6186h

- 关于宏：
    由于使用宏写的代码在反汇编后，有大量的比较字符串函数和字符串常量，函数需要重定位，字符串需要放到栈上，增加了工作量；而且生成的二进制文件也比较大。
    因此建议不使用宏，把6个函数拆开写。

- 本实验中，我把hookfsopen函数拆了出来。


##一、开始插入

###1、编写nasm汇编代码：

```
global _start
section .text
_start:
  push ebp
  mov ebp, esp
  sub esp,0x1c       ;补上dosfsopen函数被删掉的三条指令
  call hookFsOpen
  push 0x3739f6      ;dosfsopen函数第四条指令的地址
  ret

read_ebp:
  push   ebp
  mov    ebp,esp
  mov    eax,ebp
  mov    esp,ebp
  pop    ebp
  ret    
 

hookFsOpen:
  push   ebp
  mov    ebp,esp
  sub    esp,0x8
  call   read_ebp
  sub    esp,0x4
  mov    eax,[eax]
  mov    edx,[eax+0x10]

  push 0x0  
  push 0x0a
  push 0x73
  push 0x253a7325   ;这四条指令压入的是字符串 %s:%s\n

  mov eax,esp       ;把这个字符串地址保存在eax中，以便等会给printf传参数，当然也可以通过计算esp来传参数
 
  push 0x00        
  push 0x6e65706f
  mov ecx,esp          ;这里压入了字符串open

  push   edx           ;分别压入三个参数
  push   ecx
  push   eax

  mov eax,384b80h        ;调用printf
  call eax

  mov    esp,ebp
  pop    ebp
  ret    
```

###2、使用工具进行插入

```
$ python elf_tools/hook.py -f vxWorks -s `python ./elf_tools/genshellcode.py -n hookFs.nasm` -i `python ./elf_tools/genshellcode.py -i 'push 0x3d6186\nret'` -F \<dosFsOpen\>
```

- 其中，3d6186h是插入代码的起始地址。


## 二、进行测试

- 在虚拟机中，调用oprerate_file函数，打印出了字符串open:(NULL),说明打印格式没有问题，但没有取得参数

- 基本上插入和跳转都可以成功。

## 三、存在的问题：

- 建议:修改hookFs.c，把宏函数拆开写，同时减少不必要的外部函数调用。
- 问题:现在插入到了数据节没有出现系统运行的问题，但毕竟覆盖了数据的位置，因此有一定隐患。特别是现在只插入了一个函数，以后还要插入更多。



