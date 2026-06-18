# 🤖 Automated APK Build Process

This guide walks you through building your ENDY EDESON Calculator APK automatically.

---

## 🚀 Quick Start (Choose One)

### **Option A: Batch File (Simplest - Windows Only)**

```batch
build-apk-automated.bat
```

This is the easiest method for Windows users. Just double-click or run in Command Prompt.

---

### **Option B: PowerShell Script (Recommended - More Control)**

```powershell
# Make sure to run PowerShell as Administrator

# Debug APK (default)
.\Build-APK-Auto.ps1

# Release APK (for Google Play Store)
.\Build-APK-Auto.ps1 -Release

# Skip cleaning previous build
.\Build-APK-Auto.ps1 -NoClean
```

---

## 📋 Pre-Requirements

Before running automation, ensure you have installed:

- ✅ **Node.js 14+** → [Download](https://nodejs.org/)
- ✅ **Android SDK** → [Download Android Studio](https://developer.android.com/studio)
- ✅ **Java JDK 11+** → [Download](https://www.oracle.com/java/technologies/downloads/)

### Setting ANDROID_HOME (Important!)

The build process needs to know where your Android SDK is located.

**Windows:**

1. Right-click **This PC** or **My Computer** → **Properties**
2. Click **Advanced system settings**
3. Click **Environment Variables**
4. Click **New** (under System variables)
5. Set:
   - **Variable name:** `ANDROID_HOME`
   - **Variable value:** `C:\Android\sdk` (or your actual SDK path)
6. Click **OK** and restart your terminal

**Finding Your Android SDK Location:**

- **Android Studio Default:** `C:\Users\[YourUsername]\AppData\Local\Android\sdk`
- **Custom Location:** Check Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK

---

## 📊 What Each Script Does

### `build-apk-automated.bat`

**Features:**
- ✓ Checks Node.js & npm
- ✓ Installs npm dependencies
- ✓ Installs Apache Cordova
- ✓ Checks Android SDK
- ✓ Builds Debug APK
- ✓ Shows APK location & size
- ✓ Displays installation methods

**Pros:**
- Simple, straightforward
- Works on any Windows machine
- No PowerShell needed

**Cons:**
- Windows only
- Less error handling

### `Build-APK-Auto.ps1`

**Features:**
- ✓ All features of batch file
- ✓ Better error handling
- ✓ Color-coded output
- ✓ Release build support
- ✓ Optional build cleaning
- ✓ Detailed troubleshooting

**Pros:**
- More robust
- Release builds
- Better feedback
- Flexible options

**Cons:**
- Requires PowerShell
- May need execution policy adjustment

---

## 🔧 PowerShell Execution Policy

If you get an error like "cannot be loaded because running scripts is disabled":

```powershell
# Run PowerShell as Administrator, then:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then run the script again.

---

## 📱 Build Options

### Debug APK (Testing)

**Batch:**
```batch
build-apk-automated.bat
```

**PowerShell:**
```powershell
.\Build-APK-Auto.ps1
```

✓ Faster to build
✓ Can be installed on devices/emulator
✓ Good for testing
✗ Cannot be published to Google Play

---

### Release APK (For Google Play Store)

**PowerShell only:**
```powershell
.\Build-APK-Auto.ps1 -Release
```

✓ Optimized for distribution
✓ Can be published to Play Store
✗ Takes longer to build
✗ Requires keystore signing

---

## 📍 APK Output Locations

After successful build, your APK will be at:

**Debug:**
```
calculator\platforms\android\app\build\outputs\apk\debug\app-debug.apk
```

**Release:**
```
calculator\platforms\android\app\build\outputs\apk\release\app-release.apk
```

---

## 📥 Installation Methods

After build completes, you can install using:

### Method 1: Direct Installation
1. Copy APK to your Android device
2. Open file manager
3. Tap APK file
4. Confirm installation

### Method 2: ADB Command Line

```batch
# If APK is in current directory
adb install app-debug.apk

# Full path
adb install "C:\calculator\platforms\android\app\build\outputs\apk\debug\app-debug.apk"
```

### Method 3: Android Emulator

```batch
# Start emulator, then:
adb install app-debug.apk

# Or drag APK onto emulator window
```

---

## ⏱️ Build Times

- **First Build:** 10-15 minutes (downloads dependencies)
- **Subsequent Builds:** 5-10 minutes
- **Release Build:** 15-20 minutes (includes optimization)

---

## 🐛 Troubleshooting

### "ANDROID_HOME not set"

```powershell
# Check your ANDROID_HOME
$env:ANDROID_HOME

# Set it temporarily (for current session only)
$env:ANDROID_HOME = "C:\Android\sdk"

# Or set permanently (see section above)
```

### "Cordova command not found"

```batch
npm install -g cordova
```

Then close and reopen your terminal.

### "Build failed with Gradle errors"

```batch
cd platforms\android
gradlew clean
cd ..\..
cordova build android
```

### "APK not found after build"

1. Check C: drive has 5+ GB free space
2. Verify Android SDK is properly installed
3. Try: `cordova clean android` then rebuild
4. Check `platforms\android\app\build\outputs` directory exists

### "APK won't install on device"

1. Check Android version is 5.0+ (API 21+)
2. Try installing debug APK first
3. Uninstall any existing version first
4. Enable "Unknown Sources" in Settings → Security

---

## 🔐 Release Build for Google Play Store

To build a signed release APK:

```powershell
# Build release APK
.\Build-APK-Auto.ps1 -Release

# This creates: app-release.apk
```

**Next steps:**

1. Sign with your keystore (Android Studio handles this)
2. Upload to Google Play Console
3. Fill app store details
4. Submit for review

---

## 📊 APK Specifications

| Property | Value |
|----------|-------|
| **App Name** | ENDY EDESON Calculator |
| **Package** | com.endyedeson.calculator |
| **Min SDK** | API 21 (Android 5.0) |
| **Target SDK** | API 31 (Android 12) |
| **Debug Size** | ~12-15 MB |
| **Release Size** | ~8-10 MB |

---

## ✅ Build Checklist

- [ ] Node.js installed (`node --version`)
- [ ] npm available (`npm --version`)
- [ ] Android Studio installed
- [ ] Android SDK installed
- [ ] ANDROID_HOME environment variable set
- [ ] 5+ GB free disk space
- [ ] Internet connection (for downloading)
- [ ] Cordova installed (`npm install -g cordova`)

---

## 📞 Need Help?

Check the output messages during build - they often indicate what's wrong.

**Common resources:**
- Cordova Docs: https://cordova.apache.org
- Android Docs: https://developer.android.com
- Google Play Console: https://play.google.com/console

---

## 🎯 Next Steps After Build

1. ✅ Verify APK was created
2. ✅ Install on emulator or device
3. ✅ Test calculator functionality
4. ✅ Check button responses
5. ✅ Verify history feature works
6. ✅ Test on multiple Android versions
7. ✅ If successful, prepare for Play Store release

---

**Happy building! 🚀**
