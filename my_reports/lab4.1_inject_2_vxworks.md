实验：手动完成从dosFs函数到hook函数的跳转和返回



0、概述
======================

- 背景：由于函数开头没有合适的指令能够插入call指令，因此必须替换掉某几条指令

- 在上一个文档inject2vxworks in theory中提出了替换指令的方案并理论说明了可行性；

- 简单回顾这种方案：这个方案的主要思路是不加入中间层，而是把被插入的函数和插入的函数结合为“一个函数”，共同使用一个栈帧。

- 这里根据这一方法进行尝试。


1、实验前准备
======================

- 由于只是验证跳转和返回的正确性，暂时不考虑插入、重定位等工作；因此我们修改的目标镜像是编译进了hook函数的镜像，在dosFs函数开头，也包含了向hook函数的跳转
- 为了模拟一个已经完成插入但是没有跳转的环境，只需要在这个镜像中删掉调用hook的call指令即可。方法就是用一个nop串代替这个指令。

2、开始修改
======================

2.1 对dosFsOpen的修改
-----------------------

- 我们删掉dosFsOpen开头的三条指令

push ebp
mov ebp, esp
sub esp 1ch

- 修改为跳转到hook函数的起始地址

push address_hookFsOpen
ret

2.2 对hookFsOpen的修改
-----------------------

- 只需要修改结尾部分

- 结尾部分原本是：

mov esp,ebp
pop ebp
ret

- 结尾部分修改后：

mov esp,ebp
sub esp,1ch           ；补上open函数被删掉的分配空间的指令
push address<open>+6  ；跳回open函数原来的第四条指令的地址
ret

- 可以看到，是把其中的pop指令写成了新的两条指令。

3、测试
=======================

- 把修改后的vxworks镜像使用虚拟机载入，根据测试函数的输出。，发现hook成功

4、结论
======================

- 实验说明，这种不加中间层，而是把open和hook函数两者看成“一个函数”，共用一个栈帧的办法确实可行。
- 关于修改的工作量，可以进行自动实现的是对open函数开头三条指令的插入；对hook函数结尾的修改需要手动进行。
- 重定位暂时都需要手动进行





