#-*- coding: utf-8 -*-
#!/usr/bin/env python

# ====================================================================
#
# func.py
#
# 工具类
# ====================================================================

import zipfile
import os
import shutil
import pysvn

username = "Seven"
password = "kinglong"

# 编译luac路径
cocosPath = os.path.abspath('..') + "/cocos2d-console/bin/cocos"

# 读取txt文件
def readTxtFile(fileName):
    # print ("read "+fileName)
    fileObject = open(fileName)
    try:
         value = fileObject.read()
    finally:
         fileObject.close( )
    return value

# 从txt中通过热更版本号获取上次svn版本号
def readSvnVersionFromTxtByUpdateNum(filename, updateVersion):
    result = '1'
    reader = open(filename, 'r')
    pos = 0
    while True:
        line = reader.readline()
        if len(line) == 0:
            break
        if not line.startswith(updateVersion+"/"):
            continue
        pos = line.rfind(updateVersion+'/')+len(updateVersion+'/')
        posEnd = line.rfind('/Date:')
        if pos < 0:
            continue
        result = line[pos:posEnd]
    reader.close()
    return result

# 写文件
def writeFile(fileName, text, a):
    # print(fileName)
    # print(text)
    if not a:
        a = 'w+'
    fileObject = open(fileName, a)
    fileObject.write(text)
    fileObject.close()

# 压缩文件
# dirname:压缩目录
# zipfilename:目标目录
def zip_dir(dirname,zipfilename):
    print ("start zip:"+dirname+","+zipfilename)
    filelist = []
    if os.path.isfile(dirname):
        filelist.append(dirname)
    else :
        for root, dirs, files in os.walk(dirname):
            for name in files:
                filelist.append(os.path.join(root, name))
         
    zf = zipfile.ZipFile(zipfilename, "w", zipfile.zlib.DEFLATED)
    for tar in filelist:
        arcname = tar[len(dirname):]
        zf.write(tar,arcname)
    zf.close()

# 编译luac
def complie(codePath):
    print ('cocosPath = '+cocosPath)
    print ("Delete src")
    if os.path.exists(codePath + '/XXGamec/src/'):
        shutil.rmtree(codePath + '/XXGamec/src/')

    print ("Delete res")
    if os.path.exists(codePath + '/XXGamec/res/'):
        shutil.rmtree(codePath + '/XXGamec/res/')

    print ("Start package luac")
    os.system(cocosPath + ' luacompile -s ' + codePath + '/XXGame/src -d ' + codePath + '/XXGamec/src' + ' -e -k aoyue.com.xxgame.1512@tstx -b XXGAMETSTX --disable-compile')

    print ("Copy Pb files")
    if os.path.exists(codePath + '/XXGame/src/proto'):
        if os.path.exists(codePath + '/XXGamec/src/proto'):
            shutil.rmtree(codePath + '/XXGamec/src/proto')
        shutil.copytree(codePath + '/XXGame/src/proto', codePath + '/XXGamec/src/proto', ignore = shutil.ignore_patterns('*.lua'))

    print ("Copy res")
    if os.path.exists(codePath + '/XXGame/res'):
        if os.path.exists(codePath + '/XXGamec/res'):
            shutil.rmtree(codePath + '/XXGamec/res')
        shutil.copytree(codePath + '/XXGame/res', codePath + '/XXGamec/res', ignore = None)

def get_login( realm, user, may_save ):
    return True, username, password, False

def ssl_server_trust_prompt( trust_dict ):
    return (True    # server is trusted
           ,trust_dict["failures"]
           ,True)   # save the answer so that the callback is not called again

# svn提交文件
# path:提交路径
# info：提交说明
def svnCommit( path, info ):
    
    svn = pysvn.Client()
    if username != "" and password != "":
        svn.callback_get_login = get_login
    svn.callback_ssl_server_trust_prompt = ssl_server_trust_prompt
    resLs = []
    changes3 = svn.status(path)
    
    for f in changes3:
        if f.text_status == pysvn.wc_status_kind.unversioned:
            svn.add(f.path)
            print ("add:" + f.path + " <br/>")
            resLs.append(f.path)
        if f.text_status == pysvn.wc_status_kind.missing:
            print ("remove:" + f.path + " <br/>")
            svn.remove(f.path)
            resLs.append(f.path)
        if f.text_status == pysvn.wc_status_kind.modified:
            print ("modified:" + f.path + " <br/>")
            resLs.append(f.path)
    
    print(svn.checkin([path], info))
    print('commit '+path+' finish')

def svnUpdate(path):
    svn = pysvn.Client()
    if username != "" and password != "":
        svn.callback_get_login = get_login
    svn.callback_ssl_server_trust_prompt = ssl_server_trust_prompt
    svn.update(path)
    print('update '+path+'finish')