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

import func
import pysvn # http://pysvn.tigris.org/
import getopt, sys, time, string
import os, urllib
import shutil
import time
# from urlparse import urlparse #python27
import sys
# importlib.reload(sys)

from urllib.parse import urlparse #python34
cur_path = u"E:/ExcelToLua/"
svn_update_path_excel = u"E:/ExcelToLua/转表/"+sys.argv[2]
svn_update_path_lua = u"E:/ExcelToLua/转表/"+sys.argv[1]
print ("svn_update_path_excel:"+svn_update_path_excel)
save_path = u"E:/ExcelToLua/tool/save/"
target_path = cur_path + sys.argv[2]
version_html_path = save_path + sys.argv[2] + ".html"
version_txt_path = save_path + sys.argv[2] + ".txt"

username = "mgr"
password = "123456"
url  = u'https://192.168.0.254/svn/yckj/转表/' + sys.argv[2] + '/'

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
def export_diff(url, targetPath, revision_min, revision_max):
    summary = client.diff_summarize(url, revision_min, url, revision_max)
    #print summary
    for changed in summary:
        #path, summarize_kind, node_kind, prop_changed
        #for key in changed.iterkeys():
        #    print key 
        
        if pysvn.diff_summarize_kind.delete == changed['summarize_kind']:
          fullPath = targetPath+"/"+changed['path']   
          if os.path.exists(fullPath):
            os.remove(fullPath)
        
        if pysvn.diff_summarize_kind.added == changed['summarize_kind'] or pysvn.diff_summarize_kind.modified == changed['summarize_kind']:
            print (changed['summarize_kind'], changed['path'])
            if changed['node_kind'] == pysvn.node_kind.file:
                
                #uniPath = changed['path'].decode('utf8').encode()
                # file_text = client.cat(url+urllib.quote(changed['path'].encode('utf8')), revision_max) #python27
                file_text = client.cat(url+urllib.parse.quote(changed['path'].encode('utf8')), revision_max) #python34
                
                fullPath = targetPath+"/"+changed['path']    
                dirPath = fullPath[0:fullPath.rfind("/")]      
                
                if not os.path.exists(dirPath):
                    os.makedirs(dirPath)
                            
                f = open(fullPath,'wb')
                f.write(file_text)
                f.close

#导出两个版本变化的文件
def export_diff_folder(url, targetPath, revision_min, revision_max):
    folders = ''

    summary = client.diff_summarize(url, revision_min, url, revision_max)
    #print summary
    for changed in summary:
        #path, summarize_kind, node_kind, prop_changed
        #for key in changed.iterkeys():
        #    print key 
        
        if pysvn.diff_summarize_kind.delete == changed['summarize_kind']:
          fullPath = targetPath+"/"+changed['path']   
          if os.path.exists(fullPath):
            os.remove(fullPath)
        
        if pysvn.diff_summarize_kind.added == changed['summarize_kind'] or pysvn.diff_summarize_kind.modified == changed['summarize_kind']:
            if changed['node_kind'] == pysvn.node_kind.file:
                
                fullPath = targetPath+"/"+changed['path']    
                dirPath = fullPath[0:fullPath.rfind("/")]      
                folders += dirPath+','

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

def copy_files_in_dir(src, dst):

    for item in os.listdir(src):
        path = os.path.join(src, item)
        if os.path.isfile(path):
            path = add_path_prefix(path)
            copy_dst = add_path_prefix(dst)
            shutil.copy(path, copy_dst)
        if os.path.isdir(path):
            new_dst = os.path.join(dst, item)
            if not os.path.isdir(new_dst):
                os.makedirs(add_path_prefix(new_dst))
            copy_files_in_dir(path, new_dst)

def getSvnChange():
    if username != "" and password != "":
        client.callback_get_login = get_login
    print ("svn update")
    print (client.update(svn_update_path_excel))
    print (client.update(svn_update_path_lua))

    print (save_path+"version.html")
    packageVersion = func.readTxtFile(version_html_path)
    print ('packageVersion =' + packageVersion)
    svnVersionMin = func.readSvnVersionFromTxtByUpdateNum(version_txt_path, packageVersion)
    print ("read svnVersionMax form svn log")
    LogList = client.log("https://PC201703161520/svn/yckj/", pysvn.Revision( pysvn.opt_revision_kind.head ), limit=10)
    svnVersionMax = str(LogList[0].revision.number)

    print (svnVersionMax)
    print (svnVersionMin)
    if int(svnVersionMax) == int(svnVersionMin):
        print ('not have new version!!!')
        return False

    print ('write version.html and svnVersion.text')
    packageVersion = int(packageVersion) + 1
    packageVersion = str(packageVersion)

    func.writeFile(version_html_path, packageVersion, 'w')
    func.writeFile(version_txt_path, packageVersion+'/'+svnVersionMax+'/Date:'+time.strftime('%Y-%m-%d',time.localtime(time.time()))+'\n','a+')

    revision_min = pysvn.Revision( pysvn.opt_revision_kind.number, svnVersionMin )
    revision_max = pysvn.Revision( pysvn.opt_revision_kind.number, svnVersionMax )

    print ("Delete xls")
    if os.path.exists(target_path):
        shutil.rmtree(target_path)

    export_diff(url, target_path, revision_min, revision_max)

    print ("Finish,output paht:" + target_path)

    return True


