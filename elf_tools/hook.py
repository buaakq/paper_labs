#!/usr/bin/env python

# -*- coding: utf-8 -*

import sys
import os
import signal
import time
from optparse import OptionParser
from elfpatch import elfpatch
from elf_helper import *


def signal_handler(signal, frame):
    print '\nProgram Exit'
    sys.exit(0)
def basicDiscovery(FILE):
    testBinary = open(FILE, 'rb')
    header = testBinary.read(4)
    testBinary.close()
    if 'MZ' in header:
        return 'PE'
    elif 'ELF' in header:
        return 'ELF'
    else:
        'Only support ELF formats'
        return None

def main():
    signal.signal(signal.SIGINT, signal_handler)

    parser = OptionParser(usage='%prog [options]',description="inject")
    parser.add_option("-f", "--file", dest="FILE", action="store",
                      type="string",
                      help="File to patch")
    parser.add_option("-t", "--object_file", default=False,
                      dest="OBJECT_FILE", action="store",
                      help="Get text section and  add it to out file")
    parser.add_option("-s", "--shellcode", type="string",
                      dest="SHELLCODE", action="store",
                      help="User supplied shellcode, place it in text section,"
                      "make sure that it matches"
                      " the architecture that you are targeting.")
    parser.add_option("-i", "--inject_ins", type="string",
                      dest="INJECT_INS", action="store",
                      help="inject instruction into func's prolog")
    parser.add_option("-o", "--output-file", default=None, dest="OUTPUT",
                      action="store", type="string",
                      help="The backdoor output file")
    parser.add_option("-F", "--func_name", default="main",help="where inject")
    parser.add_option("-v", "--verbose", default=False, dest="VERBOSE",
                      action="store_true",
                      help="For debug information output.")

    (options, args) = parser.parse_args()
    if not options.FILE or (not options.SHELLCODE and not options.OBJECT_FILE):
        parser.print_help()
        sys.exit(1)
    if not options.OUTPUT:
        options.OUTPUT = options.FILE + ".patched"

    is_supported = basicDiscovery(options.FILE)
    if is_supported != 'ELF':
        print >>sys.stderr,"file not supported!\n"
        sys.exit(1)
    elfp = elfpatch(options.FILE,
                options.OUTPUT,
                options.SHELLCODE,
                options.OBJECT_FILE)
    (entry,inject_point) = elfp.patch_elf()
    base_addr = get_base_addr_elf(options.FILE)
    print "[+] base addr :{0:#x}".format(base_addr)
    file_offset = inject_point - base_addr
    print "[+] Patched File: {0}".format(options.OUTPUT)
    print "[+] Patched inject_point: {0:#x} file Offset: {1:#x}".format(inject_point,
        file_offset)
    funcs = parse_text_section(options.OUTPUT)
    offset = int(funcs[options.func_name]['offset'],16)
    file_offset = offset - base_addr
    print "[+] {0}: {1:#x} file offset: {2:#x}".format(options.func_name,offset,file_offset)
    if options.INJECT_INS:
      print "[+] inject prolog:"
      write_str_elf(options.OUTPUT,options.OUTPUT + '.1',file_offset,to_binary_code(options.INJECT_INS))

if __name__ == "__main__":
    main()
