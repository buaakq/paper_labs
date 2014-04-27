#!/usr/bin/env python

import commands
import sys
import shutil
import struct

def to_binary_code(shellcode):
    hex_list = shellcode.split('\\x')[1:]
    return ''.join([struct.pack('<B',int(t,16)) for t in hex_list])
'''
def get_text_section(object_file):
    """format into a shellcode string of bytes"""
    tmp = commands.getoutput("objdump -d %s" % (object_file))
    opcodes = ''
    for line in tmp.split('\n')[7:]:
      tmp = line.split(':',1)
      if len(tmp) > 1 and len(tmp[1]) > 0: tmp = tmp[1]
      else: continue
      # split on tab to get opcodes
      tmp = ''.join(tmp).split('\t')
      if len(tmp) > 1: tmp = tmp[1].strip().replace(' ','')
      if '<' in tmp: continue
      opcodes += tmp
    formatted_codes = ''.join(["\\x"+opcodes[idx]+opcodes[idx+1] for idx in range(0,len(opcodes)-1,2)])
    print >>sys.stderr,"text_section:{0}\n".format(formatted_codes)
    return formatted_codes
'''

def get_funcs_text(obj):
    '''
    return a dict like this,{'name':'foo','offset':'00ff','opcode':\x90\x90...}
    only support .o file
    '''
    out = commands.getoutput("objdump -d {0}".format(obj)).split('\n')[6:]
    funcs = []
    func = {}
    for line in out:
      t = line.split(':',1)
      #print len(t) == 2 and t[1] == '' and len(t[0].split()) == 2
      if len(t) == 2 and t[1] == '' and len(t[0].split()) == 2: #080484a0 <_fini>:
        func['name'] = t[0].split(' ')[1]
        func['offset'] = int(t[0].split(' ')[0],16)
        func['opcode'] = ''
      elif len(t) == 1 and t[0] == '':
        opcodes = func['opcode']
        func['opcode'] = ''.join(["\\x"+opcodes[idx]+opcodes[idx+1] for idx in range(0,len(opcodes)-1,2)])
        funcs.append(func)
        func = {}
      else:
        tmp = t[1].split('\t')
        #print tmp
        if len(tmp) > 1:
          func['opcode'] += tmp[1].strip().replace(' ','')
    opcodes = func['opcode']
    func['opcode'] = ''.join(["\\x"+opcodes[idx]+opcodes[idx+1] for idx in range(0,len(opcodes)-1,2)])
    funcs.append(func)
    funcs_ = {}
    for i in funcs:
      funcs_[i['name']] = {'offset':i['offset'],
          'opcode':i['opcode']}
    print funcs_
    return funcs_

def get_func_addr(elf,func):
    tmp = commands.getoutput("objdump -D {0} | grep {1}".format(elf,func))
    if len(tmp) == 0:
        print >>sys.stderr,"{0} not exits in {1}\n".format(elf,func)
        return
    # need packed
    return int(tmp.split('\n')[0].split()[0],16)

def fix_symbol(elf,output,offset,value):
    shutil.copy2(elf, output)
    with open(output,'r+') as f:
        f.seek(offset,0)
        old = struct.unpack('<I',f.read(4))[0]
        f.seek(offset,0)
        f.write(struct.pack('<I', value))
    print "fix:{0:#x}->{1:#x}\n".format(old,value)

def get_relocate_text(obj):
    tmp = commands.getoutput("readelf -r {0}".format(obj)).split('\n')[3:]
    symbs = []
    for t in tmp:
      if t == '':
        break
      if not t.split()[4].startswith('.'):
          item = {}
          item['offset'] = int(t.split()[0],16)
          item['name'] = t.split()[4]
          symbs.append(item)
    return symbs

if __name__ == '__main__':
    from elfbin import elfbin
    elfp = elfbin(sys.argv[1]) #object file
    text_base = elfp.get_section_offset(".text")
    #print ".text offset:{0:#x}\n".format(text_base)
    unsolved = get_relocate_text(sys.argv[1])
    print unsolved
    funcs = get_funcs_text(sys.argv[1])
    output = "{0}.fixed".format(sys.argv[1])
    src = sys.argv[1]

    for s in unsolved:
        addr = get_func_addr(sys.argv[2],s['name'])
        if addr == None:
          print "%s can not be solved"%(s['name'])
          continue
        print "{0}->{1:#x}\n".format(s['offset'],addr)
        fix_symbol(src,output,text_base + s['offset'],addr)
        src=output
    funcs = get_funcs_text(output)

