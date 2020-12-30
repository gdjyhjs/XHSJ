#!/bin/bash
# Copyright 2005-2007, The Android Open Source Project
#

UNITY_PATH=/Applications/Unity/Unity.app/Contents/MacOS/Unity
#change to you project root
#change to you project root
CURRENT_ROOT=$(cd `dirname $0`; pwd)
echo "CURRENT_ROOT="$CURRENT_ROOT
PROJECT_ROOT=$CURRENT_ROOT/../../
cd $PROJECT_ROOT
PROJECT_ROOT=$(pwd)
echo "PROJECT_ROOT="$PROJECT_ROOT
# svn cleanup $PROJECT_ROOT
svn update $PROJECT_ROOT --username Seven --password kinglong --no-auth-cache

#chmod 777
chmod 777 $PROJECT_ROOT/tools/luaTools/luajit2.04

python $PROJECT_ROOT/tools/autobuild/scripts/run.py $PROJECT_ROOT
#导出热更资源
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod ProjectBuild.ScriptingDefineSymbols defineSymbols:SEVEN_HOTUPDATE_PACKAGE,HUGULA_NO_LOG,HUGULA_SPLITE_ASSETBUNDLE,HUGULA_APPEND_CRC,HUGULA_RELEASE -logFile $stdout
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod ProjectBuild.ExportRes -logFile $stdout
chown -R Seven $PROJECT_ROOT

cd ..
PACKAGE_PATH=$(pwd)
echo "PACKAGE_PATH="$PACKAGE_PATH
SVN_PATH=/Users/Seven/Documents/Work/hotupdate
UPDATE_PATH=/Users/Seven/Documents/hotUpdate/update
svn cleanup $SVN_PATH
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py update $SVN_PATH/ios
rm -rf $SVN_PATH/ios
cp -rf $PACKAGE_PATH/FirstPackage/release/ios $SVN_PATH
rm -rf $UPDATE_PATH/ios
cp -rf $PACKAGE_PATH/FirstPackage/release/ios $UPDATE_PATH
chown -R Seven $SVN_PATH/ios
chown -R Seven $UPDATE_PATH/ios
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commit $SVN_PATH/ios
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitConfig $PROJECT_ROOT/Assets/Lua/config

echo "Finish"