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
