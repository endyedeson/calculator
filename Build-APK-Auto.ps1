# ENDY EDESON Calculator - Automated APK Builder (PowerShell)
# This script automates the entire APK build process for Windows

param(
    [switch]$Release = $false,
    [switch]$NoClean = $false
)

# ===== Configuration =====
$AppName = "ENDY EDESON Calculator"
$PackageName = "com.endyedeson.calculator"
$ProjectDir = Get-Location

# ===== Colors =====
$Colors = @{
    Green  = 10
    Red    = 12
    Yellow = 14
    Cyan   = 11
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  $Message" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Section {
    param([string]$Message)
    Write-Host ""
    Write-Host $Message -ForegroundColor Cyan -BackgroundColor Black
    Write-Host ""
}

# ===== Prerequisite Checks =====
function Test-Prerequisites {
    Write-Header "Checking Prerequisites..."
    
    $missing = $false
    
    # Check Node.js
    try {
        $nodeVersion = node --version
        Write-Success "Node.js found: $nodeVersion"
    } catch {
        Write-Error-Custom "Node.js not found. Install from https://nodejs.org/"
        $missing = $true
    }
    
    # Check npm
    try {
        $npmVersion = npm --version
        Write-Success "npm found: v$npmVersion"
    } catch {
        Write-Error-Custom "npm not found"
        $missing = $true
    }
    
    # Check Cordova (optional)
    try {
        cordova --version > $null 2>&1
        Write-Success "Cordova found"
    } catch {
        Write-Warning-Custom "Cordova not found (will be installed)"
    }
    
    return -not $missing
}

# ===== Install Dependencies =====
function Install-Dependencies {
    Write-Section "Step 1: Installing NPM Dependencies"
    
    try {
        npm install
        Write-Success "NPM dependencies installed"
        return $true
    } catch {
        Write-Error-Custom "Failed to install dependencies: $_"
        return $false
    }
}

# ===== Install Cordova =====
function Install-Cordova {
    Write-Section "Step 2: Installing Apache Cordova"
    
    try {
        npm install -g cordova
        Write-Success "Cordova installed globally"
        return $true
    } catch {
        Write-Error-Custom "Failed to install Cordova: $_"
        return $false
    }
}

# ===== Check Android SDK =====
function Test-AndroidSDK {
    Write-Section "Step 3: Checking Android SDK"
    
    $androidHome = $env:ANDROID_HOME
    
    if (-not $androidHome) {
        # Try common default locations
        $defaultPaths = @(
            "C:\Android\sdk",
            "$env:USERPROFILE\AppData\Local\Android\sdk"
        )
        
        foreach ($path in $defaultPaths) {
            if (Test-Path $path) {
                $androidHome = $path
                break
            }
        }
    }
    
    if ($androidHome -and (Test-Path $androidHome)) {
        Write-Success "Android SDK found at: $androidHome"
        return $true
    } else {
        Write-Warning-Custom "Android SDK not found"
        Write-Info "Please install Android Studio and set ANDROID_HOME environment variable"
        Write-Info "Download: https://developer.android.com/studio"
        return $false
    }
}

# ===== Clean Build =====
function Clean-Build {
    Write-Section "Cleaning previous build..."
    
    try {
        cordova clean android
        Write-Success "Build cleaned"
        return $true
    } catch {
        Write-Warning-Custom "Cleaning failed: $_"
        return $true  # Don't fail on this
    }
}

# ===== Build APK =====
function Build-APK {
    param([bool]$IsRelease = $false)
    
    $buildType = if ($IsRelease) { "Release" } else { "Debug" }
    Write-Section "Step 4: Building $buildType APK"
    
    Write-Info "This may take 5-15 minutes on first build..."
    Write-Info "Please be patient..."
    
    try {
        if ($IsRelease) {
            cordova build android --release
        } else {
            cordova build android
        }
        
        Write-Success "$buildType APK build completed"
        return $true
    } catch {
        Write-Error-Custom "Failed to build APK: $_"
        return $false
    }
}

# ===== Find APK File =====
function Find-APK {
    param([bool]$IsRelease = $false)
    
    if ($IsRelease) {
        $apkPath = Join-Path $ProjectDir "platforms\android\app\build\outputs\apk\release\app-release.apk"
    } else {
        $apkPath = Join-Path $ProjectDir "platforms\android\app\build\outputs\apk\debug\app-debug.apk"
    }
    
    if (Test-Path $apkPath) {
        $file = Get-Item $apkPath
        $sizeMB = [math]::Round($file.Length / 1MB, 2)
        
        return @{
            Path = $apkPath
            Size = $sizeMB
            Exists = $true
        }
    }
    
    return @{
        Path = $apkPath
        Size = 0
        Exists = $false
    }
}

# ===== Show Installation Instructions =====
function Show-InstallInstructions {
    param([hashtable]$APKInfo)
    
    Write-Section "Installation Methods"
    
    Write-Info "Method 1: Direct File Installation"
    Write-Host "  1. Transfer APK to Android device"
    Write-Host "  2. Location: $($APKInfo.Path)"
    Write-Host "  3. Tap APK file and confirm installation"
    Write-Host ""
    
    Write-Info "Method 2: ADB (Command Line)"
    Write-Host "  1. Connect Android device via USB"
    Write-Host "  2. Enable USB Debugging in Settings → Developer Options"
    Write-Host "  3. Run: adb install `"$($APKInfo.Path)`""
    Write-Host ""
    
    Write-Info "Method 3: Android Emulator"
    Write-Host "  1. Start emulator from Android Studio"
    Write-Host "  2. Run: adb install `"$($APKInfo.Path)`""
    Write-Host "  3. Or drag APK onto emulator window"
    Write-Host ""
}

# ===== Main Execution =====
function Main {
    Write-Header "$AppName - Automated APK Builder"
    
    # Check prerequisites
    if (-not (Test-Prerequisites)) {
        Write-Error-Custom "Missing required prerequisites. Exiting."
        exit 1
    }
    
    # Install dependencies
    if (-not (Install-Dependencies)) {
        Write-Error-Custom "Installation failed. Exiting."
        exit 1
    }
    
    # Install Cordova
    if (-not (Install-Cordova)) {
        Write-Error-Custom "Cordova installation failed. Exiting."
        exit 1
    }
    
    # Check Android SDK
    $sdkFound = Test-AndroidSDK
    if (-not $sdkFound) {
        Write-Warning-Custom "Continuing anyway - you may encounter errors..."
    }
    
    # Clean build if requested
    if (-not $NoClean) {
        Clean-Build
    }
    
    # Build APK
    if (-not (Build-APK -IsRelease $Release)) {
        Write-Error-Custom "APK build failed!"
        Write-Info "Troubleshooting:"
        Write-Host "  1. Ensure Android SDK is installed"
        Write-Host "  2. Set ANDROID_HOME environment variable"
        Write-Host "  3. Check you have 5+ GB free disk space"
        Write-Host "  4. Try: cordova clean android"
        Write-Host "  5. Then: cordova build android"
        exit 1
    }
    
    # Check if APK was created
    $buildType = if ($Release) { "Release" } else { "Debug" }
    $apkInfo = Find-APK -IsRelease $Release
    
    if ($apkInfo.Exists) {
        Write-Section "Build Complete! 🎉"
        Write-Success "$buildType APK successfully generated!"
        Write-Host ""
        Write-Host "  📁 Location: $($apkInfo.Path)" -ForegroundColor Green
        Write-Host "  📦 Size: $($apkInfo.Size) MB" -ForegroundColor Green
        Write-Host ""
        
        Show-InstallInstructions -APKInfo $apkInfo
        
        if (-not $Release) {
            Write-Section "For Google Play Store Release"
            Write-Info "Build signed release APK:"
            Write-Host "  .\Build-APK-Auto.ps1 -Release"
            Write-Host ""
        }
        
        Write-Header "$buildType Build Status: SUCCESS ✓"
    } else {
        Write-Error-Custom "APK file not found at: $($apkInfo.Path)"
        Write-Warning-Custom "Build may have failed silently. Check output above."
        exit 1
    }
}

# Run main
Main
