#memInit函数插入过程

##一、目的

- 本实验要在vxWorks镜像中的某个函数开头和结尾插入代码，调用sysTimestamp()获得时间，并打印出来。
- 为了达到这一目标，我们需要修改memInit的一些指令，插入一个中转代码，然后插入一个函数timestamp，这个函数负责调用systimeclock并调用printf打印时间。

##二、如何跳转到插入代码

### 2.1 开头的跳转

- 对于memInit函数，开头的指令如下：
```
push ebp,
mov epb,esp
sub esp,0x18
```
- 刚好6个字节，把他们替换为这两条指令：
```
push A
ret
```
- A是一个地址
- 在A处插入这一样一段代码：
- A的位置，只要是在VxWorks中随便找一段nop指令串即可
```
push ebp
mov ebp,esp
sub esp,8h                        ；补上memInit开头被删的指令
mov eax, timestamp函数的地址      ；把timestamp函数绝对地址放在eax中然后调用
call eax
push memInit函数地址+6             ; 回到memInit           
ret
``` 
- 解释一下这段代码的功能：从memInit跳过来之后，要先补上被删掉的三条指令，然后利用绝对地址调用timestamp函数。最后返回。
- 这样就完成在memInit开头调用时间戳函数。

### 2.2 结尾的跳转

- 最后的跳转比较简单
- 在memInit最后的ret指令之后，因为有一些无用的指令。所以我们把最后的三条指令往下挪一下，加上一个call指令。
- 即把最后的三条指令写成：
```
mov eax, timestamp函数的地址
call eax

mov esp,ebp
pop ebp
ret
```
- 这样，就在memInit结束之前又调用了一次timestamp函数

## 3、如何插入timestamp

- 这个函数就是你发给我的C语言的time.c的里面的函数，两个是一样的，所以插入一个，调用两次即可。

- 编译C语言代码后，在VxWorks镜像中找到一些nop指令串，我找到的是31146eh处有很多nop指令，就把这个函数覆盖到这里了。

- 写完之后，把31146e写到上文中代码提到的”timestamp函数的地址“中那里即可

## 4、总结：

- 共修改了原有代码的两个地方，分别是memInit开头三条指令和最后三条指令。
- 总共插入了两段代码，一段在A处，任务是在memInit开头调用时进行一个中转站的工作；一段在31146eh处，就是timestamp函数。

##附：插入的timestamp代码的汇编格式：
```
push   ebp 
mov    ebp,esp
sub    esp,0x18
mov   byte[ebp-0x8],0x25
mov   byte[ebp-0x7],0x64
mov   byte[ebp-0x6],0xa
mov   byte[ebp-0x5],0x0

mov    eax,30da80h        ;调用systimeclock
call   eax 

mov   dword[ebp-0x4],eax
sub    esp,0x8
mov    eax,dword[ebp-0x4]
push   eax 
lea    eax,[ebp-0x8]
push   eax 

mov    eax,3be7b0h         ;调用printf
call   eax 

add    esp,0x10
mov    esp,ebp
pop    ebp 
ret    
```
