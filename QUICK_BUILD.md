# ⚡ Quick Reference - APK Build Automation

## Run Build Now

### Windows Command Prompt
```cmd
build-apk-automated.bat
```

### Windows PowerShell
```powershell
.\Build-APK-Auto.ps1
```

---

## Build Options

| Command | Purpose |
|---------|---------|
| `build-apk-automated.bat` | Debug APK (fastest) |
| `.\Build-APK-Auto.ps1` | Debug APK (PowerShell) |
| `.\Build-APK-Auto.ps1 -Release` | Release APK (Google Play) |
| `.\Build-APK-Auto.ps1 -NoClean` | Skip cleanup step |

---

## Prerequisites Check

```batch
REM Check Node.js
node --version

REM Check npm
npm --version

REM Check Android SDK
echo %ANDROID_HOME%

REM Check Java
java -version
```

---

## What Gets Built

| File | Location | Size | Use |
|------|----------|------|-----|
| **app-debug.apk** | `platforms\android\app\build\outputs\apk\debug\` | 12-15 MB | Testing |
| **app-release.apk** | `platforms\android\app\build\outputs\apk\release\` | 8-10 MB | Play Store |

---

## Install on Device

```batch
REM Method 1: Direct file install
REM - Copy APK to phone
REM - Tap to install

REM Method 2: ADB
adb install app-debug.apk

REM Method 3: Emulator
REM - Drag APK onto emulator window
```

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `Node.js not found` | Install from nodejs.org |
| `ANDROID_HOME not set` | Set environment variable (see guide) |
| `Gradle build failed` | Run: `cordova clean android` then rebuild |
| `APK not found` | Check: 5+ GB free space, Android SDK installed |
| `Cannot load script` | PowerShell: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned` |

---

## Build Times

- **First build:** 10-15 minutes
- **Subsequent:** 5-10 minutes  
- **Release build:** 15-20 minutes

---

## What Happens During Build

1. ✓ Installs npm dependencies
2. ✓ Installs Cordova globally
3. ✓ Checks Android SDK
4. ✓ Compiles your HTML/CSS/JS
5. ✓ Packages as Android APK
6. ✓ Shows install options

---

## File Structure After Build

```
calculator/
├── platforms/
│   └── android/
│       └── app/
│           └── build/
│               └── outputs/
│                   └── apk/
│                       ├── debug/
│                       │   └── app-debug.apk ← Your APK here
│                       └── release/
│                           └── app-release.apk
```

---

## Useful Commands

```batch
REM Clean old build
cordova clean android

REM Rebuild
cordova build android

REM Release build
cordova build android --release

REM Check setup
cordova requirements android

REM View project info
cordova plugins

REM Global Cordova status
cordova info
```

---

**For detailed guide, see: BUILD_AUTOMATION.md**
