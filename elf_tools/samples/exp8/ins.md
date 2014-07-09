python ../../main.py -f vxWorks -I test3.nasm

python ../../elf_rel.py -t src/hook_in_src/hookFs.o -f vxWorks -o ./test2

python ../../main.py -f vxWorks -I test3.nasm

./create_nasm -f test2 -o ./test3 -p ./proxy.nasm 


