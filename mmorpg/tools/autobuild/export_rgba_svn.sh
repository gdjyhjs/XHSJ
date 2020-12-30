#!/bin/bash
# Copyright 2005-2007, The Android Open Source Project
# 获取svn改变需要分离的rgba
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

s=`python $PROJECT_ROOT/tools/autobuild/scripts/svnTextureChangeFolders.py $PROJECT_ROOT`
echo "s="$s

$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.TexturePackerBuild.BuildTextruePTFolders var:$s -logFile $stdout
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.SplitAlphaAndRGB.SplitRgbAndAFolders var:$s -logFile $stdout

u=`python $PROJECT_ROOT/tools/autobuild/scripts/svnUIChange.py $PROJECT_ROOT`
echo "u="$u
if [ "$s" != "" ];then
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.SplitAlphaAndRGB.ChangeUI -logFile $stdout
elif [ "$u" != "" ]; then
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.SplitAlphaAndRGB.ChangePrefabs var:$u -logFile $stdout
fi

chown -R Seven $PROJECT_ROOT

python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitTexture $PROJECT_ROOT/Assets/CustomerResource/Texture
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitUI $PROJECT_ROOT/Assets/CustomerResource/UI
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitConfig $PROJECT_ROOT/Assets/Lua/config

echo "Finish"