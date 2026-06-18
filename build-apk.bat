@echo off
REM =========================================================
REM ENDY EDESON Calculator - Android APK Builder
REM Automated build script for Windows
REM =========================================================

SETLOCAL ENABLEDELAYEDEXPANSION

echo.
echo ╔════════════════════════════════════════════════════╗
echo ║  ENDY EDESON Calculator - Android APK Builder      ║
echo ║  Building installable APK...                       ║
echo ╚════════════════════════════════════════════════════╝
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if npx is available
npx --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] NPX is not available
    echo Please ensure Node.js 8.2+ is installed
    pause
    exit /b 1
)

echo [✓] Node.js and npm verified
echo.

REM Option menu
echo Choose build option:
echo 1 - Install Capacitor and build for Android (Recommended)
echo 2 - Install Cordova and build for Android
echo 3 - Quick guide to use Android Studio
echo 4 - Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo.
    echo [*] Installing Capacitor dependencies...
    call npm install
    
    echo [*] Installing Capacitor CLI globally...
    call npm install -g @capacitor/cli
    
    echo [*] Installing Capacitor core packages...
    call npm install @capacitor/core @capacitor/android
    
    echo [*] Initializing Capacitor project...
    echo com.endyedeson.calculator > .capacitor-init-vars
    call npx cap init "ENDY EDESON Calculator" "com.endyedeson.calculator"
    
    echo [*] Adding Android platform...
    call npx cap add android
    
    echo [*] Syncing web assets...
    call npx cap sync
    
    echo.
    echo ╔════════════════════════════════════════════════════╗
    echo ║  Next Steps:                                       ║
    echo ║  1. Run: npx cap open android                      ║
    echo ║  2. In Android Studio:                             ║
    echo ║     Build → Build Bundle(s)/APK(s) → Build APK(s) ║
    echo ║  3. APK location:                                  ║
    echo ║     android/app/build/outputs/apk/debug/          ║
    echo ╚════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 0
)

if "%choice%"=="2" (
    echo.
    echo [*] Installing Cordova globally...
    call npm install -g cordova
    
    echo [*] Creating Cordova project...
    call cordova create calculator-cordova com.endyedeson.calculator "ENDY EDESON Calculator"
    cd calculator-cordova
    
    echo [*] Adding Android platform...
    call cordova platform add android
    
    echo [*] Building APK (debug)...
    call cordova build android
    
    echo.
    echo ╔════════════════════════════════════════════════════╗
    echo ║  Build Complete!                                   ║
    echo ║  APK location:                                     ║
    echo ║  platforms/android/app/build/outputs/apk/debug/   ║
    echo ║                                                    ║
    echo ║  To install on device:                             ║
    echo ║  adb install app-debug.apk                         ║
    echo ╚════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 0
)

if "%choice%"=="3" (
    echo.
    echo ╔════════════════════════════════════════════════════╗
    echo ║  Android Studio Manual Setup                       ║
    echo ╚════════════════════════════════════════════════════╝
    echo.
    echo 1. Download Android Studio:
    echo    https://developer.android.com/studio
    echo.
    echo 2. Create New Project:
    echo    - Choose "Empty Activity"
    echo    - Package name: com.endyedeson.calculator
    echo    - Min SDK: API 21
    echo.
    echo 3. Configure WebView:
    echo    - Add WebView to activity_main.xml
    echo    - Load local HTML files
    echo.
    echo 4. Copy Web Files to Assets:
    echo    - app/src/main/assets/
    echo    - index.html, style.css, script.js
    echo.
    echo 5. Build and Sign APK:
    echo    - Build → Build Bundle(s)/APK(s) → Build APK(s)
    echo.
    echo For complete guide, see: ANDROID_BUILD_GUIDE.md
    echo.
    pause
    exit /b 0
)

if "%choice%"=="4" (
    exit /b 0
)

echo [ERROR] Invalid choice
pause
exit /b 1
