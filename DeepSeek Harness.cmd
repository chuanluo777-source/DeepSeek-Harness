@echo off
setlocal EnableExtensions
chcp 65001 >nul
title DeepSeek Harness

rem ====== 设置（可用记事本修改）======
set "URL=http://127.0.0.1:3080"
rem APP_MODE=1: 独立应用窗口（Chrome/Edge）；APP_MODE=0: 默认浏览器标签页
set "APP_MODE=1"

rem 1. 服务已经在运行？
"%SystemRoot%\System32\curl.exe" -s -o NUL --max-time 3 "%URL%" >nul 2>&1
if %errorlevel%==0 goto open

rem 2. 启动服务（最小化窗口，日志写入 .dsh\server.log）
start "DeepSeek Harness Server" /min "%~dp0run-server.cmd"

rem 3. 等待服务就绪（最长 90 秒）
set /a tries=0
:wait
"%SystemRoot%\System32\curl.exe" -s -o NUL --max-time 2 "%URL%" >nul 2>&1
if %errorlevel%==0 goto open
set /a tries+=1
if %tries% geq 90 goto fail
>nul timeout /t 1 /nobreak
goto wait

:open
if "%APP_MODE%"=="1" (
    if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" ( start "" "%LocalAppData%\Google\Chrome\Application\chrome.exe" --app="%URL%" & goto end )
    if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" ( start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --app="%URL%" & goto end )
    if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" ( start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" --app="%URL%" & goto end )
    if exist "%LocalAppData%\Microsoft\Edge\Application\msedge.exe" ( start "" "%LocalAppData%\Microsoft\Edge\Application\msedge.exe" --app="%URL%" & goto end )
    if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" ( start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --app="%URL%" & goto end )
    if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" ( start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" --app="%URL%" & goto end )
)
start "" "%URL%"
goto end

:fail
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('DeepSeek Harness 启动超时（90 秒）。请查看日志：%USERPROFILE%\.dsh\server.log','DeepSeek Harness',0,16)"
exit /b 1

:end
exit /b 0
