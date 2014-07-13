#!/bin/bash
# written by kjw, 2014.5.5
# NOTE:
# OS version: 32 bits Ubuntu 13.04 or other Ubuntu versions 

echo "1. Creating the directory structure for Codezero sources and tools"
sudo mkdir /opt

echo "2. Installing Git"
sudo apt-get install git-core

echo "3. Installing SCons"
sudo apt-get install scons

echo "4. Installing the GCC cross-compiler"
sudo apt-get install curl

if !(command -v /opt/arm-2009q3/bin/arm-none-eabi-gcc > /dev/null 2 >& 1);then
    sudo curl -L "https://sourcery.mentor.com/public/gnu_toolchain/arm-none-eabi/arm-2009q3-68-arm-none-eabi-i686-pc-linux-gnu.tar.bz2" | bunzip2 -d --stdout | sudo tar -C /opt -xf -
fi

if !(command -v /opt/arm-2009q3/bin/arm-none-linux-gnueabi-gcc > /dev/null 2 >& 1);then
    sudo curl -L "https://smp-on-qemu.googlecode.com/files/arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2" | bunzip2 -d --stdout | sudo tar -C /opt -xf -
fi

if !(grep -q "arm-2009q3" ~/.bashrc); then
    echo -e "PATH=$PATH:/opt/arm-2009q3/bin\nexport PATH" >> ~/.bashrc
    source ~/.bashrc
fi

echo "5. Building Codezero sources"
cd ~
git clone https://github.com/jserv/codezero.git jserv-codezero
cd jserv-codezero
chmod a+x build.py
./build.py --configure
./build.py

echo "6. Installing QEMU"
sudo apt-get install qemu
#if !(command -v qemu-system-arm > /dev/null 2 >& 1);then
#    if [ ! -d "/opt/qemu-0.13.0"]; then#
#		sudo curl -L "http://wiki.qemu-project.org/download/qemu-0.13.0.tar.gz" | gzip -d --stdout | sudo tar -C /opt -xf -
#	fi
#    cd /opt/qemu-0.13.0
#    sudo ./configure
#    sudo make && make install	
# Q1: undefined reference to symbol 'timer_settime@@GLIBC_2.3.3
# Edit Makefile.target in your qemu directory, find LIBS+=-lz, add LIBS+=-lrt beneath this line.

# Q2: error: field ‘info’ has incomplete type
# struct siginfo info; => siginfo_t info; 
#fi

#echo "7. Installing Insight"
#sudo mkdir /opt/insight
#cd /opt
#echo "[enter 'anoncvs' as the password]"
#cvs -z9 -d :pserver:anoncvs@sourceware.org:/cvs/src login
#sudo cvs -z9 -d :pserver:anoncvs@sourceware.org:/cvs/src co -r gdb_6_8-branch insight

echo "8. GDB configuration"
cd ~/jserv-codezero
cp ./tools/gdbinit ~/.gdbinit

echo "9. Running Codezero"
cd ~/jserv-codezero
echo -e "cd build\nqemu-system-arm -s -kernel final.elf -m 128 -M versatilepb -nographic; pkill qemu-system-arm\ncd .." > ./tools/run-my-qemu
chmod a+x ./tools/run-my-qemu
./tools/run-my-qemu


