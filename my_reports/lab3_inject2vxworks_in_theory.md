TOPIC：在vxworks镜像中插入hook函数方法的理论验证


0、概述
===================

- 由于在dosFs*函数中，开头的指令比较难以替换成call指令进行对hook的调用，因此我建议删掉3条指令，修改成push+ret指令

- 下面的代码以dosFsOpen中跳转到hookFsOpen为例

- 本来说要写个小实验，验证这个方法的可行性；但是我发现自己编写的简单的C语言函数的寄存器和堆栈使用情况远没有这里的具体的函数复杂，即使实验成功也没有说服力；

- 所以这个文档那个只是理论上说明一下，下一个文档将直接实践在vxworks上的可行性。


1、修改dosFsOpen
===================================

- 我们删掉dosFsOpen开头的三条指令

push ebp
mov ebp, esp
sub esp 1ch

- 这三条指令6个字节，替换成：

push address_hookFsOpen
ret

- 这样，也刚好六个字节。


2、修改hookFsOpen
=====================================

- 编译出来的hookFsOpen代码大概是这样的：

- 开头部分：

push ebp
mov ebp,esp


- 结尾部分：

mov esp,ebp
pop ebp
ret

- 修改后的代码应该是这样：

- 开头部分不用修改：

push ebp
mov ebp,esp

- 结尾部分修改后：

mov esp,ebp
sub esp,1ch
push address<open>+6  ;跳回open函数原来的第四条指令的地址
ret

{要求}：要求在对hook函数进行编码时，直接使用ebp读取栈上传给open函数的参数。


3、可行性的理论证明
========================

- 模拟寄存器和堆栈的情况，证明这么修改是可行的。

3.1寄存器的使用
-----------------------

- 由于在hook函数中，edi,esi,ebx三个寄存器被保存和恢复了；因此不会影响到open函数中这三个寄存器的使用

- 由于在跳转到hook函数的时候，eax,ecx,edx三个寄存器还没开始用，因此hook中无论如何使用，都不会污染这三个寄存器。


3.2 堆栈的情况（即esp和ebp的使用和恢复）
-----------------------

- 刚进入open函数的时候，堆栈如下：

	---------------
ebp->	saved ebp   
        ----------------

	调用open函数的函数的栈帧

	---------------
esp->	return address
	---------------

- open函数刚开始的三条指令，就是让堆栈变化为：


	--------------
        saved ebp(the old one)
	----------------

        调用open函数的函数的栈帧

        ---------------
	return address
        ---------------
ebp->	saved ebp(the new one)
   	---------------
	1ch的空间
esp->	---------------
	

- 我们既然删掉了这三条指令，就要在跳转回来的时候，让堆栈变成这个样子。

- 我们在hook函数中，不断地分配和使用栈空间，最后，只需要回收esp，即mov esp,ebp,堆栈就变为：

        --------------
        saved ebp(the old one)
        ----------------

        调用open函数的函数的栈帧

        ---------------
        return address
        ---------------
ebp&esp->  saved ebp(the new one)
        ---------------


然后再减esp，分配一个1ch的空间，补上我们删掉指令的那个效果即可，然后堆栈就变成了
        --------------
        saved ebp(the old one)
        ----------------

        调用open函数的函数的栈帧

        ---------------
        return address
        ---------------
ebp->   saved ebp(the new one)
        ---------------
        1ch的空间
esp->   ---------------

- 这就是open函数三条指令之后的堆栈状态了。

- 因此，有了上述的修改方案。
