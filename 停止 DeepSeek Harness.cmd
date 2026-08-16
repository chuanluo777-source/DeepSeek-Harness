@echo off
chcp 65001 >nul
title 停止 DeepSeek Harness
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop.ps1"
echo.
pause
