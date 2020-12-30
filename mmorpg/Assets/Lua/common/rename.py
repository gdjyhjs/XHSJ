#coding=utf-8 
import os
import sys
import shutil

def renameFile(path):
	for root, dirs, files in os.walk(path):
	    for name in files:
	    	count = 1
	        if name.rfind(".FBX") >= 0:
	        	pos = name.rfind("_", 0, 8)
	        	newname = root + '/' + name[0:pos] + '@' + name[pos+1:len(name)]
	            os.rename(os.path.join(root,name),os.path.join(root,count))
	            count = count+1

print sys.argv[1]
renameFile(sys.argv[1])
