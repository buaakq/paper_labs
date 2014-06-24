#!/usr/bin/env python

import sys
import os
import signal
import time
from optparse import OptionParser
from elfpatch import elfpatch
from elf_helper import *
from genshellcode import *


def main():
    parser = OptionParser(usage='%prog [options]', description="")
    
    parser.add_option("-t", "--object_file", default=False,
                      dest="OBJECT_FILE", action="store",
                      help="Get text section and  add it to out file    ")

    (options, args) = parser.parse_args()

    func = parse_text_section(options.OBJECT_FILE)

    print func

if __name__ == "__main__":
    main()
