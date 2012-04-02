#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib2
import re
try:
    from hashlib import md5
except ImportError:
    from md5 import md5

debug = False

def getWiktionaries(dicts):
    fileRE = re.compile("pages-meta-current.xml.bz2$")
    
    for lang in dicts:
    
        if debug:
            wiktmd5 = open(lang + "wiktionary-latest-md5sums.txt")
        else:
            wiktmd5 = urllib2.urlopen("http://dumps.wikimedia.org/" + lang + "wiktionary/latest/" + lang + "wiktionary-latest-md5sums.txt")
    
        found = False
        for line in wiktmd5:
            if fileRE.search(line):
                found = True
                if not (md5(open(lang + "wiktionary-latest-pages-meta-current.xml.bz2",'rb').read()).hexdigest() == line.strip().split(" ")[0]):
                    WikiBZ = open(lang + "wiktionary-latest-pages-meta-current.xml.bz2",'wb')
                    WikiBZ.write(urllib2.urlopen("http://dumps.wikimedia.org/" + lang + "wiktionary/latest/" + lang + "wiktionary-latest-pages-meta-current.xml.bz2").read())
                    WikiBZ.close()
        wiktmd5.close()
    
        if not found:
            print "problem with bgwiktionary-latest-md5sums.txt"

if __name__ == '__main__':
    getWiktionaries(['en','bg'])
