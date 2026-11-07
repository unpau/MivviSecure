@echo off
chcp 65001 >nul
title Mivvi Secure - Jalankan di Chrome
cd /d "%~dp0"
echo ====================================================
echo   MIVVI SECURE v2 - MENJALANKAN DEMO DI CHROME
echo ====================================================
echo.
where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Flutter belum ditemukan di PATH.
  echo Instal Flutter, tambahkan flutter\bin ke PATH,
  echo lalu buka terminal baru dan coba lagi.
  echo Panduan: https://docs.flutter.dev/install/with-vs-code
  echo.
  pause
  exit /b 1
)
echo [1/2] Memasang dependensi Flutter...
call flutter pub get
if errorlevel 1 (
  echo.
  echo [ERROR] flutter pub get gagal. Kirim screenshot pesan ini.
  pause
  exit /b 1
)
echo.
echo [2/2] Membuka Mivvi Secure di Chrome...
call flutter run -d chrome
if errorlevel 1 (
  echo.
  echo [ERROR] Aplikasi belum berjalan. Cek flutter doctor.
  pause
  exit /b 1
)
pause
