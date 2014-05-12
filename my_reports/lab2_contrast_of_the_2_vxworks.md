〇、概述
=========================

本文档大概描述两个vxworks镜像的区别:
镜像A：没有写入hook函数vxworks原始的镜像；
镜像B：写入了hook函数的vxworks的镜像。

源代码的区别：与A相比，B唯一多了的就是在以下6个函数dosFs*的函数体中，分别调用hookFs*；
例如在dosFsOpen的开始处（其实是在局部变量初始化之后），调用hookFsOpen(),来实现相应的功能；返回后继续执行dosFsOpen

LOCAL DOS_FILE_DESC_ID dosFsOpen
     (
     DOS_VOLUME_DESC_ID  pVolDesc, /* pointer to volume descriptor */
     char *      pPath,  /* dosFs full path/filename */
     int         flags,  /* file open flags */
     int         mode    /* file open permissions (mode) */
     )
     {
	/*先让局部变量初始化*/
     DOS_FILE_DESC_ID    pFd = NULL;
     u_int       errnoBuf;
     BOOL        devSemOwned = FALSE;    /* device semaphore privated */
     BOOL        fileSemOwned = FALSE;   /* file semaphore privated */
     BOOL        error = TRUE;           /* result condition */
 
	/*调用hook函数*/
         hookFsOpen();

............................
}

由于实际项目中，不能修改源代码，而是在二进制层面上进行修改，插入跳转和hook函数；因此研究这个例子，看看如果改动源代码的话，会在编译之后的镜像中产生什么差异；摸清处规律之后，我们就可以依样花葫芦，进行插入即可。

本文档以dosFsOpen和hookFsOpen为例


一、dosFsOpen函数在镜像中的区别
===============================

源代码中，dosfsopen函数只插入了一条函数调用语句，因此在反汇编后的镜像中，B比A之多了一条call指令:
即:call hookFsOpen


二、被插入的hookFsOpen()
==================================

暂略。


三、看反汇编的代码，发现的ABI如下：
==================================

1、参数的传递

- 使用栈进行传参，位置靠后的参数先入栈（即位置靠前的参数位于低地址；位置靠后的位于高地址）。

2、寄存器的使用，

- 调用者保存寄存器：eax,ecx,edx
- 被调用者保存寄存器：ebx,edi,esi
- 使用eax传递返回值

3、发现在dosFsRead等函数中，虽然有一个参数使用了FAST关键字，但是参数传进来的方式，还是通过栈；因此如果要在hook函数中使用这个参数，直接读栈即可。



四、总结
================================

总结一下：要在二进制层面插入代码，应该在什么位置注入什么代码。

dosFsOpen函数中：
-------------------------------
1、在dosFsOpen的合适位置，加入一条call指令，调用插入的函数。（意味着需要删掉至少一条指令，call指令需要5字节）
2、插入的位置，最好就模仿整体编译工程时，代码中call指令的位置。因为如果插入位置太靠后，可能会在hook函数中污染上层函数使用的寄存器，如eax等，而eax默认又是调用者保存的；生成的汇编代码不会保存和恢复eax等，还需要手动加入代码保存，因此就比较麻烦了。
3、所以，插入位置应该满足：被hook的函数还没有开始用eax,ecx,edx

hookFsOpen函数中：
-------------------------------
1、使用C代码正常生成的二进制代码
2、最好在代码的开始，就补上在上一层函数中因为添加call指令而删掉的指令。如果这样做不方便，需要在结尾处补上的话，更需要仔细检查，不能污染被hook函数的寄存器。
（暂时还没想到哪种情况，因为最后才补上被删掉的指令而导致问题）
3、代码的最后，还是像正常生成的代码一样ret返回即可。
