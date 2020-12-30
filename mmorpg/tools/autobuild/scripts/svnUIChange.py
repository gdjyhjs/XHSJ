# -*- coding: UTF-8 -*- 

# Author:Seven
# 获取UI变化的文件夹，用来重新合成大图

import func
import pysvn # http://pysvn.tigris.org/
import getopt, sys, time, string
import os, urllib
import shutil
import time
from urlparse import urlparse #python27
import sys
# importlib.reload(sys)

# from urllib.parse import urlparse #python34

cur_path = sys.argv[1]
# print("cur_path:"+cur_path)
version_html_path = cur_path + "/tools/autobuild/scripts/UIVer.html"
version_txt_path = cur_path + "/tools/autobuild/scripts/UIVer.txt"

username = "Seven"
password = "kinglong"
url  = u'https://192.168.0.254/svn/yckj/美术需求和出图/UI/UI输出/UI/'

svnVersionMin = 0
svnVersionMax = 0
packageVersion = 0

def ssl_server_trust_prompt( trust_dict ):
    return (True    # server is trusted
           ,trust_dict["failures"]
           ,True)   # save the answer so that the callback is not called again

client = pysvn.Client()
client.callback_ssl_server_trust_prompt = ssl_server_trust_prompt

def init_revision():
    revision_min = pysvn.Revision( pysvn.opt_revision_kind.number, svnVersionMin )
    revision_max = pysvn.Revision( pysvn.opt_revision_kind.number, svnVersionMax )
    return revision_min, revision_max
    
def init_url(url):   
    # urlObject = urlparse(url)
    # if urlObject.scheme == 'http' or urlObject.scheme == 'https':
    #     url = urlObject.scheme+"://"+urlObject.netloc+urllib.quote(urlObject.path.decode(sys.stdin.encoding).encode('utf8'))
    # else:
    #     url = unicode(url, sys.stdin.encoding)
    # print "sys.stdin.encoding = " + sys.stdin.encoding
        
    if not url.endswith("/"):
        url = url + "/"        
    return url
def get_login( realm, user, may_save ):
    return True, username, password, False

#导出两个版本变化的文件
def export_diff_folder(url, revision_min, revision_max):
    folders = ''
    dic = {}

    summary = client.diff_summarize(url, revision_min, url, revision_max)
    #print summary
    for changed in summary:
        #path, summarize_kind, node_kind, prop_changed
        #for key in changed.iterkeys():
        #    print key 
        
        # if pysvn.diff_summarize_kind.delete == changed['summarize_kind']:
        #   fullPath = targetPath+"/"+changed['path']   
        #   if os.path.exists(fullPath):
        #     os.remove(fullPath)
        
        if pysvn.diff_summarize_kind.added == changed['summarize_kind'] or pysvn.diff_summarize_kind.modified == changed['summarize_kind']:
            if changed['node_kind'] == pysvn.node_kind.file:  
                dirPath = changed['path']      
                
                if dirPath.rfind('.prefab')>=0 and dirPath.rfind('.meta') <0:
	                dic[dirPath] = dirPath
	                # print(folder)

    for key,folder in dic.items():
    	folders += folder+","
    print(folders)

def os_is_win32():
    return sys.platform == 'win32'

def add_path_prefix(path_str):
    if not os_is_win32():
        return path_str

    if path_str.startswith("\\\\?\\"):
        return path_str

    ret = "\\\\?\\" + os.path.abspath(path_str)
    ret = ret.replace("/", "\\")
    return ret

def getSvnChange():
    if username != "" and password != "":
        client.callback_get_login = get_login

    packageVersion = func.readTxtFile(version_html_path)
    svnVersionMin = func.readSvnVersionFromTxtByUpdateNum(version_txt_path, packageVersion)
    LogList = client.log("https://192.168.0.254/svn/yckj/", pysvn.Revision( pysvn.opt_revision_kind.head ), limit=10)
    svnVersionMax = str(LogList[0].revision.number)
    # print(svnVersionMax)
    # print(svnVersionMin)
    # print(packageVersion)
    if int(svnVersionMax) == int(svnVersionMin):
        print ('')
        return False

    packageVersion = int(packageVersion) + 1
    packageVersion = str(packageVersion)

    func.writeFile(version_html_path, packageVersion, 'w')
    func.writeFile(version_txt_path, packageVersion+'/'+svnVersionMax+'/Date:'+time.strftime('%Y-%m-%d',time.localtime(time.time()))+'\n','a+')

    revision_min = pysvn.Revision( pysvn.opt_revision_kind.number, svnVersionMin )
    revision_max = pysvn.Revision( pysvn.opt_revision_kind.number, svnVersionMax )

    export_diff_folder(url, revision_min, revision_max)

    return True

getSvnChange()


