#!/bin/bash
# Copyright 2005-2007, The Android Open Source Project
# 分离ui图片agba
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

#导出热更资源
$UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod ProjectBuild.ExportRGBAndA -logFile $stdout
# $UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.TexturePackerBuild.BuildTextruePT -logFile $stdout
# $UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.SplitAlphaAndRGB.SplitRgbAndAlphaChannel -logFile $stdout
# $UNITY_PATH -quit -batchmode -projectPath $PROJECT_ROOT -executeMethod Seven.SplitAlphaAndRGB.ChangeUI -logFile $stdout
chown -R Seven $PROJECT_ROOT

python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitTexture $PROJECT_ROOT/Assets/CustomerResource/Texture
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitUI $PROJECT_ROOT/Assets/CustomerResource/UI
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitConfig $PROJECT_ROOT/Assets/Lua/config

cd ..
EFFECT_PATH=$(pwd)
echo "EFFECT_PATH="$EFFECT_PATH
python $PROJECT_ROOT/tools/autobuild/scripts/commit.py commitEffect $EFFECT_PATH/EffectRGBA

echo "Finish"