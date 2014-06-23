#what's here?
##AIM
- hook 6 fs functions.
- printf time and path only. 

##FILES

###create_nasm
####It can:
- a shell script,used to create nasm file from hookFs.o file.
- the script first disassemble the .o file and modify the nasm file to suitable format
- then patch 6 proxy
- delete spare instructions.

####It cannot:
- relocate

###hook_src
- hookFs.c .o and .h
- dosFsLib.c

###nasm
- proxy.nasm: 6 proxies
- hookFs0.nasm: disassembled from .o file using objdump 
- test: created by create_nasm
