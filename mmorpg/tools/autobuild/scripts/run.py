# -*- coding: UTF-8 -*- 

# Author:Seven
# 

import sys
import os
import func

path = sys.argv[1]

ver = func.readTxtFile(path+"/tools/autobuild/scripts/ver.txt")
ver = str(int(ver)+1)
func.writeFile(path+"/tools/autobuild/scripts/ver.txt", ver, "w")
func.writeFile(path+"/Assets/Hugula/Config/Version.txt", "0.0."+ver, "w")