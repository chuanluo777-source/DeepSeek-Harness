@echo off
title DeepSeek Harness Server
set "NODE=C:\Program Files\nodejs\node.exe"
set "CLI=%USERPROFILE%\.dsh\profiles\node_modules\@deepseek-ai\dsh\lib\bin.js"
set "NPX=C:\Program Files\nodejs\npx.cmd"
set "DSH_HOME=%USERPROFILE%\.dsh"
set "LOG=%DSH_HOME%\server.log"

if not exist "%NODE%" (
    echo [错误] 找不到 Node.js：%NODE% >> "%LOG%"
    exit /b 1
)

echo ==== %date% %time% 启动 DeepSeek Harness ==== >> "%LOG%"
if exist "%CLI%" (
    "%NODE%" "%CLI%" web >> "%LOG%" 2>&1
) else if exist "%NPX%" (
    "%NPX%" --yes @deepseek-ai/dsh web >> "%LOG%" 2>&1
) else (
    echo [错误] 找不到 dsh 启动程序，且 npx 不可用 >> "%LOG%"
    exit /b 1
)
echo ==== 退出代码 %errorlevel% ==== >> "%LOG%"
