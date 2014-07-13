#使用工具注入文件监控代码的实验

##〇、实验目的

- 在已经完成的重定位工具elf-rel.py和main.py等的基础上。

- 以一个.o文件（hookFs.o）和VxWorks文件为输入，输出一个vxWorks.patched。
- vxworks.patched将具有文件监控的功能。

##一、实验准备

- 编写文件监控功能源代码，见hookFs.c
- 在torndao中编译为hookFs.o

- 该代码实现的功能仅为打印相应的操作名称，但在劫持函数中，既进行了外部函数的调用，也进行了内部函数的调用，以测试重定位功能。结果证明重定位成功。

- 准备一个带有dosFs文件系统的VxWorks系统镜像文件，其中定义一个用户程序，进行一些文件操作，如打开、读写和关闭一个文件。

- 准备一个proxy.nasm文件，其中写好代理层的代码


##二、实现步骤

###1、构造一个hookFs0.o备用

```
$ objdump -d -Mintel hookFs.o > hookFs0.s
$ ./modify_nasm2 -f hookFs0.s  -o hookFs0.nasm 
$ nasm hookFs0.nasm -o hookFs0.o
```

- 这样就会生成一个hookFs0.o，这个文件的用处在于，通过对它进行分析（parse_text_section），来得到各个函数的实际插入地址。

- 因为如果直接分析hookFs.o，由于各个函数存在空隙，得到的地址并不会是后面按照紧凑模式插入的地址。

- 由于shell脚本modify_nasm2删除了函数间的无用代码，因此hookFs0.o是紧凑的。

### 2、反汇编并重定位hookFs.o,得到汇编文件hookFs.s

```
$ python ../../elf_rel.py -t hookFs.o -f vxWorks -j hookFs0.o -o hookFs.o
```
- 在这里我们用到了hookFs.o，它除了帮助重定位之外没有用处。


### 3、修整hookFs.s得到hookFs.nasm 

- 接下来把hookFs.s与proxy.nasm合并，得到hookFs.nasm 用于插入
```
$ ./modify_nasm -f hookFs.s -o hookFs.nasm -p proxy.nasm 
```
- 这样一来，就可以利用hookFs.nasm向VxWorks中插入了

### 4、插入到VxWorks

```
$ python ../../main.py -f vxWorks -I hookFs.nasm 
```

- 在虚拟机中运行VxWorks.patched，可以发现劫持成功，截图略。



## 三、总结

- 至此，对VxWorks进行.o文件的插入已经基本排除了所有的技术问题

- 尤其是对call指令的重定位问题，实现的elf_rel.py程序能够自动地发现识别call指令调用的是哪个函数，无论是本地函数还是外部函数，都能够准确地利用相对寻址重定位。




