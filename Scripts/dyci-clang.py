#!/usr/bin/env python
# This is just clang proxy. Actual clang is in clang.backup
# == CLANG_PROXY ==

import hashlib

import subprocess
import sys
import os
from clangParams import parseClangCompileParams
from subprocess import Popen
from sys import stdout, stderr
#
#print('Input args is [' + ' '.join(sys.argv[1:]) + ']')

#loading old params
indexFileLocation = os.path.expanduser('~/.dyci/index/')
clangParams = parseClangCompileParams(sys.argv[1:])
className = clangParams['class']

filename = indexFileLocation + hashlib.md5(className).hexdigest()

try:
    with open(filename, "w") as text_file:
        workingDirectory = os.getcwd()
        text_file.write('\n'.join(sys.argv[1:] + [workingDirectory]))
        text_file.close()
except:
    #stderr.write("Couldn't write index file '%s' %s. This is bad:( But compilation will be continued" % (className, className.hash))
    pass

#faking compile string...
#... Since we are clang...
#... There's somewere clang-real near us..
addition = ''
if (sys.argv[0][-2:] == '++'):
  addition = '++' 

process = Popen(['xcrun', '-find', 'clang'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
output, err = process.communicate()
  
clangReal   = output.strip() + addition

stderr.write('!' + clangReal + '!')

compileString = [clangReal] \
                + sys.argv[1:]

#Compiling file again
process = Popen(compileString,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
output, err = process.communicate()

# emulating output / err
stdout.write(output)
stderr.write(err)

# if process returned error code, returning it
if process.returncode != 0:
    exit(process.returncode)