objcopy的使用

〇、概述
===============================
objcopy是一个GNU实用工具，可以用于可执行文件格式的转化，以及操作可执行文件的section等；因此我们猜测该工具可能能够用于在vxworks镜像中插入新段。
这里做实验验证和进行说明。

一、实验：
==============================

实验内容：
-----------------------------

1、生成两个静态链接的ELF可执行文件，分别是简单地打印hello和goodbye；
2、通过把goodbye的text节和其他需要的节，提取出来插入到hello中
3、当执行hello时，可以先打印hello,再打印goodbye

实验过程
----------------------------

1、提取段：

要实现打印goodbye，至少需要代码节和只读数据节（字符串goodbye位于.rodata节），先提取这两个节：

kq@kq: ~/objcopy$    objcopy -j .text goodbye text_goodbye
kq@kq: ~/objcopy$    objcopy -j .rodata goodbye rodata_goodbye

这样就生成了两个文件，分别是 text_goodbye和rodata_goodbye，用readelf观察他们，发现他们都仍然是ELF文件，以rodata_goodbye为例,其节头表如下

kq@kq:~/objcopy$ readelf -S rodata_goodbye 
There are 5 section headers, starting at offset 0x1ced0:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .rodata           PROGBITS        080c8980 000980 01c52c 00   A  0   0 32
  [ 2] .shstrtab         STRTAB          00000000 01ceac 000023 00      0   0  1
  [ 3] .symtab           SYMTAB          00000000 01cf98 0011c0 10      4 204  4
  [ 4] .strtab           STRTAB          00000000 01e158 001556 00      0   0  1


可见此时rodata在内存中也是分配了虚拟地址的。此外，还有符号表、字符串表也被包含了进来。


2、插入段：

把刚才提取出来的两个section插入到hello可执行文件中：

kq@kq:~/objcopy$ objcopy --add-section _text=text_goodbye hello hello.add
kq@kq:~/objcopy$ objcopy --add-section _rodata=rodata_goodbye hello.add hello.add

新段的段名分别叫_text和_rodata（区分于原文件的.text .rodata），新文件名叫做hello.add


3、新文件一瞥

但是，新文件的情况并不乐观，我们在hello.add中的节头表找到了插入的两个新节：

kq@kq:~/objcopy$ readelf -S hello.add | grep -E "_rodata|_text" 
  [28] _rodata           PROGBITS        00000000 0accf5 01f6ae 00      0   0  1
  [29] _text             PROGBITS        00000000 0cc3a3 08a84f 00      0   0  1

可惜，objcopy在为我们插入两个新节的时候，并没有为两个节分配虚拟地址；然而，我发现objcopy有个功能，就是为某个section或者全部section指定新的地址。于是，我们为_text制定一个新的地址：

kq@kq:~/objcopy$ objcopy hello.add --change-section-address _text1=0x8100000

kq@kq:~/objcopy$ readelf -S hello.add | grep "_text"
  [29] _text             PROGBITS        08100000 0cc3a3 08a84f 00      0   0  1

果然，_text节有了我们指定的地址。

然而，问题在于，这个节并不会随着可执行文件的加载而加载，因为加载器是根据程序段表（program header table）的划分来加载的；我们的新节并没有被映射到内存地址空间。然后objcopy并没有提供修改段和节映射的功能。

所以，即使我们重定为新节，并在程序开始后添加跳转，执行我们的新节的代码，也肯定是无法成功的（访问越界，提示segmentation fault）。




二、总结
=======================================

1、objcopy提供提取节和插入节的功能；

2、objcopy插入节时，只做了这几件事：
	修改section table，新建一个节（位置位于文件靠后的部分，在字符串表上面），其大小就是要插入节的大小；
	把要插入的节的内容拷贝到新节处；

3、objcopy在插入节的时候，并没有完成：

	为新节提供虚拟加载地址；（这一点可以利用objcopy修改section地址来完成）
	为新节与段建立映射；（没有提供这一功能）
	为节中的符号引用重定位。（没有提供这一功能）

4、综上所述：objcopy在插入新节时，用来做为我们对vxworks插入的工具，只能帮我们完成建立节和节内容的复制，并不能做到完全。



































