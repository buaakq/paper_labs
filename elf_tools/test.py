#!/usr/bin/env python

import sys
import os
import signal
import time
from optparse import OptionParser
from elfpatch import elfpatch
from elf_helper import *
from genshellcode import *

def relocate(rel):
    for k in rel:
      k['result'] = -4 + k['sym_addr'] - k['rel_addr']
      k.pop('sym_addr')
      k.pop('rel_addr')
    return rel 

def get_sym_addr(rel,vxworks):
    syms = parse_text_section(vxworks)
    for k in rel:
      sym_name = k['sym_name']
      if sym_name in syms:
        k['sym_addr'] =int(syms[sym_name]['offset'],16)
        k.pop('sym_name')
    return rel
    

def get_func_addr(rel,func):
    inject_point = '3d6186'
    for t in rel:
      func_name = t['func_name']
      if func_name in func:
        inject_offset = int(func[func_name]['offset'],16)
        func_addr = int(inject_point,16) + inject_offset
        t['rel_addr'] = func_addr + t['offset2func']
        t.pop('offset2func')
        t.pop('func_name')
    return rel 

def modify_rel_table(rel,sym):
    sym_reverse = sym[::-1]
    #print sym_reverse
    for t in rel:
      rel_off = t['rel_offset']
      #print rel_off
      for k in sym_reverse:
        func_off = k['func_offset']
        if rel_off >= func_off:
           t['func_name'] = k['func_name']
           t['offset2func'] = rel_off - func_off
           break
    return rel    

def get_relocate_text(obj):
    tmp = commands.getoutput("readelf -r {0}".format(obj)).split('\n')[3:]
    symbs = []
    for t in tmp:
      if t == '': 
        break
      if not t.split()[4].startswith('.'):
        if t.split()[3] == '00000000':
          item = {}
          item['rel_offset'] = int(t.split()[0],16)
          item['sym_name'] = t.split()[4]
          symbs.append(item)
    return symbs

def get_symtab_text(obj):
    tmp = commands.getoutput("readelf -s {0}".format(obj)).split('\n')[3:]
    symbs = []
    for t in tmp:
      if t == '':
        break
      if ((t.split()[3] == 'FUNC') and (t.split()[4] == 'GLOBAL')):
        item = {}
        item['func_name'] = t.split()[7]
        item['func_offset'] = int(t.split()[1],16) 
        symbs.append(item)
    return symbs


def main():
    parser = OptionParser(usage='%prog [options]', description="")
    
    parser.add_option("-t", "--object_file", default=False,
                      dest="OBJECT_FILE", action="store",
                      help="Get text section and  add it to out file    ")

    parser.add_option("-f","--file",dest="FILE",action=
                    "store", type="string")
    (options, args) = parser.parse_args()

    func = parse_text_section(options.OBJECT_FILE)
    rel_table = get_relocate_text(options.OBJECT_FILE)
    sym_table = get_symtab_text(options.OBJECT_FILE)
    rel_table = modify_rel_table(rel_table, sym_table)
    
    funcs = parse_text_section(options.OBJECT_FILE)
    rel_table = get_func_addr(rel_table,funcs)
    rel_table  = get_sym_addr(rel_table,options.FILE)  
    
    rel_table = relocate(rel_table) 
     
    #print funcs

    #print func
    #print sym_table   
    print rel_table

if __name__ == "__main__":
    main()
