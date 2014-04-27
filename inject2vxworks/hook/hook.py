#!/usr/bin/env python

import sys
import os
import signal
import time
from optparse import OptionParser
from elfpatch import elfpatch


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
                      help="User supplied shellcode, make sure that it matches"
                      " the architecture that you are targeting."
                      )
    parser.add_option("-o", "--output-file", default=None, dest="OUTPUT",
                      action="store", type="string",
                      help="The backdoor output file")
    parser.add_option("-n", "--section", default="sdata", dest="NSECTION",
                      action="store", type="string",
                      help="New section name must be "
                      "less than seven characters")
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
    result = elfp.patch_elf()
    if result is True:
        print "Patched File: {0}".format(options.OUTPUT)

if __name__ == "__main__":
    main()