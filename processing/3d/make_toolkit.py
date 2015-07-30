#!/usr/bin/python

import os

dirname = 'toolkitsource'
filename = 'distoolkit.pde'

with open(filename, 'w') as output:
    for f in os.listdir(dirname):
        name, extension = os.path.splitext(f)
        print name, extension
        if extension == '.pde' and name != dirname:
            with open('%s/%s' % (dirname, f), 'r') as f2:
                print f2
                output.write(f2.read())



