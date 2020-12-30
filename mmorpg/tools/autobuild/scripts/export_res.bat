set CURRENT_ROOT=%~dp0
set PAN=%~d0
%PAN%
cd %CURRENT_ROOT%
cd ..\..\..\
set PROJECT_ROOT=%cd%
echo %PROJECT_ROOT%
set UNITY_PATH="C:\Program Files\Unity\Editor\Unity.exe"

svn update %PROJECT_ROOT%
rem run.py %PROJECT_ROOT%
rem %UNITY_PATH% -projectPath %PROJECT_ROOT% -quit -batchmode -executeMethod ProjectBuild.ExportRes -logFile $stdout
echo "ExportRes  sccuess"
%PROJECT_ROOT%\tools\autobuild\scripts\commit.py %PROJECT_ROOT%\tools\autobuild
pause