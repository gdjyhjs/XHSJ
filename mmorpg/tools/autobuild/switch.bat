set CURRENT_ROOT=%~dp0
set PAN=%~d0
%PAN%
cd %CURRENT_ROOT%
cd ..\..\
set PROJECT_ROOT=%cd%
echo %PROJECT_ROOT%

svn sw https://192.168.0.254/svn/yckj/美术需求和出图/UI/UI输出/Texture %PROJECT_ROOT%\Assets\CustomerResource\Texture --ignore-ancestry
svn sw https://192.168.0.254/svn/yckj/美术需求和出图/UI/UI输出/UI %PROJECT_ROOT%\Assets\CustomerResource\UI --ignore-ancestry
svn sw https://192.168.0.254/svn/yckj/转表/lua_dev %PROJECT_ROOT%\Assets\Lua\config --ignore-ancestry
svn sw https://192.168.0.254/svn/yckj/server/game/protocol %PROJECT_ROOT%\Assets\Lua\sproto --ignore-ancestry
svn sw https://192.168.0.254/svn/yckj/server/game/enum %PROJECT_ROOT%\Assets\Lua\enum --ignore-ancestry

echo "switch sce"
pause
