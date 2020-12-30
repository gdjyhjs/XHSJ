#!/bin/sh
#UNITY path

#change to you project root
#change to you project root
CURRENT_ROOT=$(cd `dirname $0`; pwd)
echo "CURRENT_ROOT="$CURRENT_ROOT
PROJECT_ROOT=$CURRENT_ROOT/../../
cd $PROJECT_ROOT
PROJECT_ROOT=$(pwd)
echo "PROJECT_ROOT="$PROJECT_ROOT

svn sw https://192.168.0.254:443/svn/yckj/%E7%BE%8E%E6%9C%AF%E9%9C%80%E6%B1%82%E5%92%8C%E5%87%BA%E5%9B%BE/UI/UI%E8%BE%93%E5%87%BA/Texture $PROJECT_ROOT/Assets/CustomerResource/Texture --ignore-ancestry
svn sw https://192.168.0.254:443/svn/yckj/%E7%BE%8E%E6%9C%AF%E9%9C%80%E6%B1%82%E5%92%8C%E5% 87%BA%E5%9B%BE/UI/UI%E8%BE%93%E5%87%BA/UI $PROJECT_ROOT/Assets/CustomerResource/UI --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/client/mmorpg/Assets/CustomerResource/Texture $PROJECT_ROOT/Assets/CustomerResource/Texture --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/client/mmorpg/Assets/CustomerResource/UI $PROJECT_ROOT/Assets/CustomerResource/UI --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/%E7%BE%8E%E6%9C%AF%E9%9C%80%E6%B1%82%E5%92%8C%E5%87%BA%E5%9B%BE/UI/UI%E8%BE%93%E5%87%BA/Texture $PROJECT_ROOT/Assets/CustomerResource/TTexture --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/%E7%BE%8E%E6%9C%AF%E9%9C%80%E6%B1%82%E5%92%8C%E5%87%BA%E5%9B%BE/UI/UI%E8%BE%93%E5%87%BA/UI $PROJECT_ROOT/Assets/CustomerResource/TUI --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/%E8%BD%AC%E8%A1%A8/lua_dev $PROJECT_ROOT/Assets/Lua/config --ignore-ancestry
svn sw https://192.168.0.254:443/svn/yckj/server/game/protocol $PROJECT_ROOT/Assets/Lua/sproto --ignore-ancestry
svn sw https://192.168.0.254:443/svn/yckj/server/game/enum $PROJECT_ROOT/Assets/Lua/enum --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/client/mmorpg/Assets/Lua/config $PROJECT_ROOT/Assets/Lua/config --ignore-ancestry
# svn sw https://192.168.0.254:443/svn/yckj/%E8%BD%AC%E8%A1%A8/lua_dev $PROJECT_ROOT/Assets/LuaTableOptimizer/Config --ignore-ancestry

chown -R Seven $PROJECT_ROOT/Assets/CustomerResource/Texture
chown -R Seven $PROJECT_ROOT/Assets/CustomerResource/UI
chown -R Seven $PROJECT_ROOT/Assets/Lua/config
chown -R Seven $PROJECT_ROOT/Assets/Lua/sproto
chown -R Seven $PROJECT_ROOT/Assets/Lua/enum
chown -R Seven $PROJECT_ROOT/Assets/LuaTableOptimizer/Config

echo "Finish"