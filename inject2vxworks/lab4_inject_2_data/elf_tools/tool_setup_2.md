% 实现外部函数的注入
% 冯力
% 2014-04-26


1. 目标程序源码如下

```
$ cat test/exp2/main2.c
#include <stdio.h>

void main() {
  printf("main2\n");
}

$ ./test/exp2/main2
main2
```

2. 待注入函数如下
----------------

```
$ cat test/exp2/foo.c
#include <stdio.h>

void foo() {
  printf("foo1");
}
```

3. 使用我们的工具来注入
---------------------

```
$ python hook.py -f test/exp2/main2 -s `python genshellcode.py -n test/exp2/inject2.nasm` -i `python genshellcode.py -i 'push 0x8048544\nret'`
[*] Gathering file info
[*] Patching Binary
[!] Patching Complete
[+] Patched File: test/exp2/main2.patched
[+] Patched inject_point: 0x8048544 file Offset: 0x544
[+] main :0x804840c file offset: 0x40c
[+] inject prolog:
\x55\x89\xe5\x83\xe4\xf0
\x68\x44\x85\x4\x8\xc3
write:\x55\x89\xe5\x83\xe4\xf0->\x68\x44\x85\x4\x8\xc3

$ ./test/exp2/main2.patched.1
foo1
main2
```

4. 注入的汇编代码如下
-------------------

这里利用汇编语言的优势，使用label实现相对跳转，非常方便。当有多个被注入函数的话，我们需要多个proxy，使用label跳转到相应的函数，非常方便。

同时这里还是用了conv.py这个工具，该工具的目的是尽量将非text段的内容，如这里的.ro.data段的数据，
也就是printf函数打印的format常量部分放到了栈上，这样就可以减轻注入其他段的工作量，实验显示该方法可行。

具体的做法是，将常量字符串分成四个字节一组，按照地址顺序放到栈上。由于栈是向下增长的，所以首先放入的是后面的字符，然后依次向前。首先先判断
字符串的长度是否被4整除，否则，在尾部填充\0字节，然后分组填充，同时要注意的是，使用push指令后面的数是小端位序（X86），所以要按照合适的顺序构造。


```
global _start
section .text
_start:
    push ebp
    mov ebp,esp
    and esp,0xfffffff0

    call foo

    push 0x8048412
    ret

foo:
    push   ebp
    mov    ebp,esp
    sub    esp,0x18
    push   0x316f6f66 ;foo1
    ;lea    eax,[esp]
    ;push   eax
    push   esp
    mov    eax,0x80482f0
    call   eax
    leave
    ret
```
