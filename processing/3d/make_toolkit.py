#!/usr/bin/python

import os

dirname = 'toolkitsource'
filename = 'distoolkit.pde'

abspath = os.path.dirname(os.path.realpath(__file__))
absdirname = abspath + '/' + dirname
absfilename = abspath + '/' + filename

with open(filename, 'w') as output:
    for f in os.listdir(absdirname):
        print f
        name, extension = os.path.splitext(f)
        if extension == '.pde' and name != dirname:
            with open('%s/%s/%s' % (abspath, dirname, f), 'r') as f2:
                output.write(f2.read())

print(filename + ' created.')
