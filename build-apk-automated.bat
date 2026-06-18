@echo off
REM =========================================================
REM ENDY EDESON Calculator - Automated APK Builder
REM Full automation script for Windows
REM =========================================================

SETLOCAL ENABLEDELAYEDEXPANSION

echo.
echo ╔════════════════════════════════════════════════════╗
echo ║  ENDY EDESON Calculator - APK Builder              ║
echo ║  Full Automation Script                            ║
echo ╚════════════════════════════════════════════════════╝
echo.

REM Check Node.js
echo [*] Checking prerequisites...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)
echo [OK] Node.js is installed

REM Check npm
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm is not available
    pause
    exit /b 1
)
echo [OK] npm is available

echo.
echo ═══════════════════════════════════════════════════════
echo Step 1: Installing NPM dependencies
echo ═══════════════════════════════════════════════════════
echo.

call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install npm dependencies
    pause
    exit /b 1
)

echo.
echo ═══════════════════════════════════════════════════════
echo Step 2: Installing Apache Cordova globally
echo ═══════════════════════════════════════════════════════
echo.

call npm install -g cordova
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install Cordova
    pause
    exit /b 1
)

echo.
echo ═══════════════════════════════════════════════════════
echo Step 3: Checking Android SDK
echo ═══════════════════════════════════════════════════════
echo.

if defined ANDROID_HOME (
    echo [OK] ANDROID_HOME is set: !ANDROID_HOME!
) else (
    echo [WARNING] ANDROID_HOME not set
    echo Default location: C:\Android\sdk
    echo If Android SDK is installed elsewhere, set ANDROID_HOME environment variable
    echo.
)

echo.
echo ═══════════════════════════════════════════════════════
echo Step 4: Building Debug APK
echo ═══════════════════════════════════════════════════════
echo.
echo This may take 5-15 minutes on first build...
echo.

call cordova build android

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] APK build failed!
    echo.
    echo Troubleshooting steps:
    echo 1. Ensure Android SDK is installed (Download Android Studio)
    echo 2. Set ANDROID_HOME environment variable to your Android SDK path
    echo 3. Ensure you have 5+ GB free disk space
    echo 4. Try: cordova clean android ^&^& cordova build android
    echo.
    pause
    exit /b 1
)

echo.
echo ═══════════════════════════════════════════════════════
echo Build Complete!
echo ═══════════════════════════════════════════════════════
echo.

REM Find APK file
set APK_PATH=platforms\android\app\build\outputs\apk\debug\app-debug.apk

if exist "%APK_PATH%" (
    echo [SUCCESS] APK generated successfully!
    echo.
    echo APK Location: %CD%\%APK_PATH%
    echo.
    
    for /f "tokens=*" %%A in ('powershell -Command "'{0:N2}' -f ((Get-Item '%APK_PATH%').Length / 1MB)"') do set SIZE=%%A
    echo APK Size: %SIZE% MB
    echo.
    
    echo ═══════════════════════════════════════════════════════
    echo Installation Options
    echo ═══════════════════════════════════════════════════════
    echo.
    echo 1. Transfer APK to Android device
    echo    - Location: %CD%\%APK_PATH%
    echo    - Copy to phone via USB/email/cloud
    echo    - Tap APK file to install
    echo.
    echo 2. Using ADB (Command Line)
    echo    - Connect device via USB and enable USB Debugging
    echo    - Run: adb install "%APK_PATH%"
    echo.
    echo 3. Using Android Emulator
    echo    - Start emulator from Android Studio
    echo    - Run: adb install "%APK_PATH%"
    echo    - Or drag APK onto emulator window
    echo.
    
    echo ═══════════════════════════════════════════════════════
    echo Release APK (for Google Play Store)
    echo ═══════════════════════════════════════════════════════
    echo.
    echo To build a signed release APK, run:
    echo   cordova build android --release
    echo.
    echo Then sign it with your keystore and upload to Google Play Console
    echo.
    
) else (
    echo [ERROR] APK file not found at expected location
    echo Expected: %CD%\%APK_PATH%
    echo.
    pause
    exit /b 1
)

echo.
pause
exit /b 0
