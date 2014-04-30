#尝试使用elfsh对vxworks进行插入

##〇、概述

- elfsh有个命令reladd，可以用于把一个.o可重定位文件注入到elf可执行文件中。
- 该命令实现以下几个方面：
    - 1、把.o文件中的所有代码节、数据节、bss节等插入到可执行文件中，为他们分配合适的运行时地址；并更新节头表；
    - 2、更新段表，把新插入的节设为加载的。
    - 3、解析.o文件的符号表，并合并到elf可执行文件中。
    - 4、根据.o文件的重定位表，对新插入的所有节进行符号引用的重定位。（例如，新插入代码调用了printf函数，只要在可执行文件的符号表中存在printf，那就会把新插代码的引用指向printf的地址；同样，新插代码段对自身的数据段的引用也会被重定位。）
    
##一、插入尝试

- 准备好原始的vxworks镜像和编译好的hookFs.o文件

```
$ ls -l

total 4076
-rw------- 1 kq kq    3316  4月 30 10:04 hookFs.o
-rw------- 1 kq kq 1337184  4月 30 10:06 original_vxworks

$ readelf -S original_vxworks 
There are 12 section headers, starting at offset 0x11fd50:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00308000 000060 0c3290 00 WAX  0   0 32
  [ 2] .data             PROGBITS        003cb2a0 0c3300 014780 00  WA  0   0 32
  [ 3] .bss              NOBITS          003dfa20 0d7a80 009880 00  WA  0   0 16
  [ 4] .debug_aranges    PROGBITS        00000000 0d7a80 000060 00      0   0  1
  [ 5] .debug_pubnames   PROGBITS        00000000 0d7ae0 001378 00      0   0  1
  [ 6] .debug_info       PROGBITS        00000000 0d8e58 03a2f4 00      0   0  1
  [ 7] .debug_abbrev     PROGBITS        00000000 11314c 000ee7 00      0   0  1
  [ 8] .debug_line       PROGBITS        00000000 114033 00bca9 00      0   0  1
  [ 9] .shstrtab         STRTAB          00000000 11fcdc 000071 00      0   0  1
  [10] .symtab           SYMTAB          00000000 11ff30 017600 10     11 3028  4
  [11] .strtab           STRTAB          00000000 137530 00f230 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

```
- 可以看到，原来的镜像只有一个代码段，一个数据段和bss段；下面我们写好一个elf脚本：
```
$ cat reladd.sh 
#!/usr/bin/elfsh

#加载两个文件
load original_vxworks
load hookFs.o

#把.o插入到可执行文件
reladd 1 2

#保存修改后的新文件
save new_vxworks

#退出elfsh
quit
```

- 运行这个脚本试一下:
```

$ elfsh reladd.sh

	 The ELF shell 0.83 (32 bits built) .::. 

 	 .::. This software is under the General Public License V.2 
	 .::. Please visit http://www.gnu.org 

~quiet  
 [*] Set ELFsh default color theme (use nocolor to disable) 

 [*] /home/kq/.elfshrc sourcing -OK- 
 [*] Type help for regular commands 


we are in script mode from revm_loop ! 
~load  original_vxworks 

 [*] Wed Apr 30 14:06:34 2014 - New object loaded : original_vxworks

~load  hookFs.o 

 [*] Wed Apr 30 14:06:34 2014 - New object loaded : hookFs.o

~reladd  1 2 

 [*] ET_REL hookFs.o injected succesfully in ET_EXEC original_vxworks

~save  new_vxworks 

 [*] Object new_vxworks saved successfully 

~quit  

 [+] Unloading workspace : 0 (local) *
 	[*] Unloading object 1 (hookFs.o)   
 	[*] Unloading object 2 (original_vxworks) * 
	 .:: Bye -:: The ELF shell 0.83 

 [*] Removing 2 FIFO from server side 

```

- 插入成功了，再看一下新的文件里面多了什么：

```
$ readelf -S new_vxworks 
There are 15 section headers, starting at offset 0x131bfc:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00308000 003060 0c3290 00 WAX  0   0 32
  [ 2] .data             PROGBITS        003cb2a0 0c6300 014780 00  WA  0   0 32
  [ 3] .bss              NOBITS          003dfa20 0daa80 009880 00  WA  0   0 16
  [ 4] hookFs.o.bss      PROGBITS        003ea000 0e5000 001000 00  WA  0   0  0
  [ 5] hookFs.o.text     PROGBITS        003eb000 0e6000 000604 00  AX  0   0  0
  [ 6] .elfsh.hooks      PROGBITS        003ec000 0e7000 004000 00  AX  0   0  0
  [ 7] .debug_aranges    PROGBITS        00000000 0e9904 000060 00      0   0  1
  [ 8] .debug_pubnames   PROGBITS        00000000 0e9964 001378 00      0   0  1
  [ 9] .debug_info       PROGBITS        00000000 0eacdc 03a2f4 00      0   0  1
  [10] .debug_abbrev     PROGBITS        00000000 124fd0 000ee7 00      0   0  1
  [11] .debug_line       PROGBITS        00000000 125eb7 00bca9 00      0   0  1
  [12] .shstrtab         STRTAB          00000000 131b60 000099 00      0   0  1
  [13] .symtab           SYMTAB          00000000 131e54 017790 10     14 3028  4
  [14] .strtab           STRTAB          00000000 1495e4 00f347 00     13   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

```

- 多了三个新的节（原先12个节，现在有15个）
- 原来的text和data的位置和大小都没有变化，说明插入没有改变原来的代码和数据
- 新插入的节的运行时地址分配在了原来的bss的后面（这部分空间能不能用还不一定，因此可能导致失败）
- 符号表、字符串表的位置和大小都发生了变化

##二、手动写入proxy

- 虽然暂时完成了插入，但是还没有hook
- 为了尽快测试插入是否成功，我手动写入了proxy，hook了open函数。原理还是：
```
open--->proxy--->hookFsOpen--->proxy--->open
```

##三、进行测试

- 然而，当尝试用vxworks虚拟机载入该映像的时候，却出现了“load error”，说明载入文件的过程中发生了错误；
- 错误来源很可能是新插入的段分配了非法的虚拟地址。

##四、结论和改进措施

###4.1 如何继续使用elfsh
- 首先需要找到为什么发生load error，即到底是不是使用了非法地址
- 如果是使用了非法地址，可以通过两种办法解决：   
 
    - 1、修改elfsh源代码，使新插入的节插到text前或者其他合法的虚拟地址
    - 2、修改vxworks的BSP的配置，使它认为我们插入的节使用了合法的地址。

###4.2 如果不再使用elfsh，而是用python脚本插入
- 可以得到以下的教训：由于扩展了代码节，新插入的节是否会插入到了非法的地址？








