#-*- coding: utf-8 -*-
#!/usr/bin/env python

# ====================================================================
#
# svnchanged_export.py
#
# Export Files in a revision Range
# Usage: svnchanged_export.py -r beginRev:endRev --username user --password passwd url targetPath
# Author: Rock Sun( http://rocksun.cn )
# Site: http://rocksun.cn/svnchanged-export/
# ====================================================================

import sys
import func

svn_path = u'/Users/Seven/Documents/Work/hotupdate'
def run():
	print(sys.argv[1]+":"+sys.argv[2])
	if sys.argv[1] == "update":
		func.svnUpdate(sys.argv[2])

	if sys.argv[1] == "commit":
		func.svnCommit(sys.argv[2],"hot update commit")

	if sys.argv[1] == "commitConfig":
		func.svnCommit(sys.argv[2],"hot update commit")

	if sys.argv[1] == "commitTexture":
		func.svnCommit(sys.argv[2],"texture commit")

	if sys.argv[1] == "commitUI":
		func.svnCommit(sys.argv[2],"texture commit")

	if sys.argv[1] == "commitEffect":
		func.svnCommit(sys.argv[2],"commitEffect commit")
run()