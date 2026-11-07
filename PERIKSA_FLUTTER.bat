@echo off
chcp 65001 >nul
title Pemeriksaan Flutter
cd /d "%~dp0"
flutter --version
flutter doctor -v
pause
