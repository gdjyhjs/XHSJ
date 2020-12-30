#coding:utf-8
import os
import sys

path = sys.argv[1]
for root, dirs, files in os.walk(path):
	# movie_name = os.listdir(files)
	for name in files:
	    if name.rfind(".FBX") >= 0:
	    	pos = name.rfind("_", 0, 8)
	    	newname = name[0:pos] + '@' + name[pos+1:len(name)]
	        os.rename(os.path.join(root,name),os.path.join(root,newname))