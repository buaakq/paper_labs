实验：使用中转代码proxy的open到hook的跳转实验

〇、概述
===============

- 本实验是在lab_inject_2_vxworks的基础上进行的
- 本实验的改进是在直接跳转的基础上加了一层proxy代码，调用过程如下:

```
 	   push+ret	     call               ret          push+ret
dosFsOpen ----------> proxy ------> hookFsOpen ------> proxy --------> dosFsOpen

```

- 说明：在open和proxy之间的跳转使用的是push+ret绝对地址跳转； 
- 在proxy和hook之间使用call调用和正常的ret返回；其中call分别尝试了绝对地址（需要先把绝对地址mov到寄存器）和相对地址


一、开始修改
===============

1、找到一个地方放置proxy
--------------

- 由于暂时不考虑插入，因此需要找到一串nop来放置proxy的代码。

```
3a19e8:
	push ebp
	mov ebp,esb
	sub esp,1ch       ； 这三条指令是open函数开头被替换掉的指令
	mov eax,3a3f90h   ；把hook函数的绝对地址放入eax
	call eax
	push 3a08d6h      ；压入open函数第四条指令的地址
	ret	          ；返回到open函数

```

- 这里的proxy共用掉了19个字节。


2、修改open函数的入口处
----------------

- 前三条指令修改为

```
3a08d0:
	push 3a19e8h   ；压入proxy代码的位置
	ret
```

3、对于hook函数
----------------

- 由于使用了proxy补全了open中被删除的代码，并且使用正常的call指令调用hook函数，因此hook不需要进行任何的修改。


三、测试
====================

- 在虚拟机环境中，该镜像正常运行并成功hook了open函数。


四、问题
===================

- 在从proxy中使用call指令调用hook函数时，曾尝试使用间接寻址；但是运行时发生了错误（页错误）；改用绝对寻址后正常
- 还没有发现问题所在。
