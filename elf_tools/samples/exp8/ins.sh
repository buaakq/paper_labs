#!/bin/bash

if [ $# -lt 3 ] ; then
    cat << EOF
NAME:
  modify_nasm   ---- 修整格式并生成合适的nasm文件

SYNOPSIS:
  modify_nasm -f s_file -p proxy_file -o output_file   

OPTIONS:
    -f    ------   the path of assembly file
    -o    ------   the file name of the output_file
    -p    ------   the path of the proxy nasm file

EXAMPLE
    modify_nasm -f ./hook_src -o hookFs.nasm -p ./proxy.nasm
EOF
    exit 0
fi

while getopts ":f:o:p:" opt;
do
   case $opt in
      f )  o_file=$OPTARG ;;
      o ) out_file=$OPTARG ;;
      p ) proxy_file=$OPTARG ;;
      ? ) echo "error"
          exit 1;;

  esac
done

