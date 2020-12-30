set CURRENT_ROOT=%~dp0
set PAN=%~d0
%PAN%
cd %CURRENT_ROOT%
cd ..\..\
set PROJECT_ROOT=%cd%
echo %PROJECT_ROOT%
set UNITY_PATH="C:\Program Files\Unity\Editor\Unity.exe"

svn update %PROJECT_ROOT%
%PROJECT_ROOT%\tools\autobuild\scripts\run.py %PROJECT_ROOT%
%UNITY_PATH% -quit -batchmode -projectPath %PROJECT_ROOT% -executeMethod ProjectBuild.ExportRes -logFile $stdout
echo "ExportRes  sccuess"

cd ..
HOT_PATH = %cd%
%PROJECT_ROOT%\tools\autobuild\scripts\commit.py %HOT_PATH%\FirstPackage\release\android
pause