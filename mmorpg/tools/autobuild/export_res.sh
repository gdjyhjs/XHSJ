#!/bin/sh
#UNITY path
UNITY_PATH=/Applications/Unity/Unity.app/Contents/MacOS/Unity
#change to you project root
#change to you project root
CURRENT_ROOT=$(cd `dirname $0`; pwd)
echo "root"$CURRENT_ROOT
PROJECT_ROOT=$CURRENT_ROOT/../../
cd $PROJECT_ROOT
PROJECT_ROOT=$(pwd)
echo $PROJECT_ROOT
svn update $PROJECT_ROOT

#chmod 777
chmod 777 $PROJECT_ROOT/tools/luaTools/luajit2.04

python $PROJECT_ROOT/tools/autobuild/scripts/run.py $PROJECT_ROOT
#导出热更资源
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod ProjectBuild.ExportRes -logFile $stdout

cd ..
PACKAGE_PATH=$(pwd)
echo $PACKAGE_PATH
SVN_PATH=/Users/Seven/Documents/Work/热更
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py update
rm -rf $SVN_PATH/android
cp -rf $PACKAGE_PATH/FirstPackage/release/android $SVN_PATH
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commit

echo "Finish"