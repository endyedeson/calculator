# 🎯 APK Build Automation - Complete Setup Guide

## Overview

Your ENDY EDESON Calculator is now ready for automated Android APK building! This guide walks you through everything.

---

## 📋 What Was Created

### 1. **Batch Script** (`build-apk-automated.bat`)
- Simplest method for Windows
- Double-click to run
- Automatic error checking
- No PowerShell needed

### 2. **PowerShell Script** (`Build-APK-Auto.ps1`)
- More advanced features
- Better error handling
- Release build support
- Flexible options

### 3. **Documentation**
- `BUILD_AUTOMATION.md` - Full guide (6,900+ words)
- `QUICK_BUILD.md` - Quick reference
- This file - Setup guide

---

## 🚀 Getting Started (5 Steps)

### Step 1: Install Prerequisites

**Download and install (if not already installed):**

1. **Node.js** → https://nodejs.org/ (choose LTS)
2. **Android Studio** → https://developer.android.com/studio (includes Android SDK)
3. **Java JDK** → https://www.oracle.com/java/technologies/downloads/ (version 11 or higher)

**Verify installations:**
```batch
node --version          # Should show v14+
npm --version          # Should show 6.0+
java -version          # Should show Java 11+
```

### Step 2: Set ANDROID_HOME Environment Variable

This tells the build tools where your Android SDK is located.

**Windows 10/11:**

1. Open **Settings**
2. Search for "environment variables"
3. Click "Edit the system environment variables"
4. Click "Environment Variables" button
5. Click "New" under "System variables"
6. Enter:
   - Variable name: `ANDROID_HOME`
   - Variable value: `C:\Users\[YourUsername]\AppData\Local\Android\sdk`
     (or wherever your Android SDK is installed)
7. Click OK, OK, OK
8. **Restart your computer** or close/reopen terminal

**Verify it's set:**
```batch
echo %ANDROID_HOME%   # Should show path to SDK
```

### Step 3: Open Terminal in Project Directory

```batch
# Navigate to calculator folder
cd \path\to\calculator

# Or if already there
cd calculator
```

### Step 4: Run the Build Script

**Choose ONE method:**

#### Method A: Batch File (Simplest)
```batch
build-apk-automated.bat
```

#### Method B: PowerShell
```powershell
# First time only: allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then run
.\Build-APK-Auto.ps1
```

### Step 5: Wait for Build to Complete

The script will:
1. ✓ Check prerequisites
2. ✓ Install npm dependencies (~2 min)
3. ✓ Install Apache Cordova (~1 min)
4. ✓ Verify Android SDK
5. ✓ Build the APK (~10 min on first run)
6. ✓ Show APK location

**Total time: 10-15 minutes on first build**

---

## 📍 APK Location

After successful build, your APK will be at:

```
YOUR_PROJECT_FOLDER\
└── platforms\
    └── android\
        └── app\
            └── build\
                └── outputs\
                    └── apk\
                        └── debug\
                            └── app-debug.apk  ← HERE!
```

**File size:** ~12-15 MB (Debug), ~8-10 MB (Release)

---

## 📱 Install on Your Phone/Emulator

### Option 1: Direct Installation (Easiest)

1. Copy the APK file to your Android phone
2. Open file manager on phone
3. Tap the APK file
4. Tap "Install"
5. Done!

### Option 2: Using ADB (Command Line)

```batch
# Connect your Android device via USB
# Enable USB Debugging in Settings → Developer Options

adb install "C:\path\to\app-debug.apk"
```

### Option 3: Using Android Emulator

```batch
# Start Android emulator from Android Studio
# Then:
adb install "C:\path\to\app-debug.apk"

# Or drag & drop APK onto emulator window
```

---

## 🔄 Build Options (PowerShell Only)

### Debug Build (Testing)
```powershell
.\Build-APK-Auto.ps1
```
- Faster to build
- Good for testing
- Cannot publish to Play Store

### Release Build (Google Play Store)
```powershell
.\Build-APK-Auto.ps1 -Release
```
- Optimized for distribution
- Can be published to Play Store
- Takes longer
- Need keystore for signing

### Skip Cleanup
```powershell
.\Build-APK-Auto.ps1 -NoClean
```
- Skips the cleanup step
- Faster rebuild if nothing changed

---

## 📊 Build Statistics

| Metric | Value |
|--------|-------|
| **First Build Time** | 10-15 minutes |
| **Subsequent Builds** | 5-10 minutes |
| **Release Build** | 15-20 minutes |
| **Debug APK Size** | 12-15 MB |
| **Release APK Size** | 8-10 MB |
| **Disk Space Required** | 5+ GB |
| **Supported Android** | 5.0+ (API 21+) |

---

## ✅ Verification Checklist

Before running the build, verify:

```batch
✓ Node.js installed:
  node --version

✓ npm installed:
  npm --version

✓ Java installed:
  java -version

✓ Android SDK installed:
  (Should exist at location in ANDROID_HOME)

✓ ANDROID_HOME set:
  echo %ANDROID_HOME%

✓ 5+ GB free disk space
  (Check disk properties)

✓ Internet connection active
  (For downloading dependencies)
```

---

## 🐛 Troubleshooting

### "Node.js not found"
**Solution:** Install from https://nodejs.org/ and restart terminal

### "ANDROID_HOME not set"
**Solution:** Follow Step 2 above and restart terminal

### "Cordova command not found"
**Solution:** Run `npm install -g cordova` in terminal

### "Build failed" or "Gradle error"
**Solution:** 
```batch
cd platforms\android
gradlew clean
cd ..\..
cordova build android
```

### "PowerShell script cannot be loaded"
**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "APK file not created"
**Check:**
1. Did build complete without errors?
2. Do you have 5+ GB free disk space?
3. Is Android SDK properly installed?
4. Check `platforms\android\app\build` directory exists

### "APK won't install on phone"
**Check:**
1. Phone Android version is 5.0+ (Settings → About → Version)
2. "Unknown Sources" enabled (Settings → Security)
3. Remove old version first (Settings → Apps)
4. Try debug APK first
5. Check phone has enough storage (500+ MB free)

---

## 🎯 What Happens During Build

```
START
  ↓
Check Node.js/npm ← Needed for build tools
  ↓
Install npm dependencies ← Project packages
  ↓
Install Cordova ← Web-to-native wrapper
  ↓
Check Android SDK ← Native build tools
  ↓
Compile web files (HTML/CSS/JS)
  ↓
Package as Android app
  ↓
Generate APK file
  ↓
SUCCESS! APK ready for installation
```

---

## 📚 Additional Resources

### Quick Reference
- **File:** `QUICK_BUILD.md`
- **Contains:** Commands, troubleshooting, build options

### Full Documentation
- **File:** `BUILD_AUTOMATION.md`
- **Contains:** Detailed guide, all options, advanced usage

### Original Android Guide
- **File:** `APK_QUICK_START.md`
- **Contains:** Capacitor setup, manual build steps

### Build Guide (Technical)
- **File:** `ANDROID_BUILD_GUIDE.md`
- **Contains:** Technical details, structure, optimization

### Main Documentation
- **File:** `README.md`
- **Contains:** Calculator features, keyboard shortcuts, accessibility

---

## 🎯 Next Steps After Successful Build

1. ✅ Install APK on device/emulator
2. ✅ Test calculator functionality
3. ✅ Verify all buttons work
4. ✅ Test on different Android versions
5. ✅ Share with friends/users
6. ✅ (Optional) Publish to Google Play Store

---

## 🔐 Google Play Store (Optional)

To publish your APK to Google Play Store:

1. Create developer account (one-time $25 fee)
2. Build release APK: `.\Build-APK-Auto.ps1 -Release`
3. Sign APK with your keystore
4. Upload to Google Play Console
5. Fill app store details
6. Submit for review (24-72 hours)

---

## 💡 Pro Tips

1. **First build is slowest** - Downloads all dependencies (10-15 min)
2. **Subsequent builds faster** - Uses cached dependencies (5-10 min)
3. **Clean build if stuck** - Run: `cordova clean android`
4. **Check disk space** - Build needs 5+ GB free
5. **Use batch file first** - Simple and reliable
6. **Release build smaller** - ~3-5 MB smaller than debug

---

## 📞 Common Questions

### Q: Do I need to run the script every time?
**A:** No. Once built, APK is ready to use. Run again only to rebuild after code changes.

### Q: Can I install on multiple devices?
**A:** Yes! Copy APK to any Android 5.0+ device and install.

### Q: Is the APK free to distribute?
**A:** Yes! It's your own app. You can share, sell, or publish it.

### Q: How long until I can test it?
**A:** 10-15 minutes on first run, then 5-10 minutes for rebuilds.

### Q: Can I build on Mac/Linux?
**A:** Yes, but use `./build-apk.sh` instead (in original scripts).

---

## 🎉 Summary

You now have **automated APK building** for your calculator!

### What You Can Do Now:
- ✅ Build APK in 15 minutes
- ✅ Install on any Android phone
- ✅ Share with friends
- ✅ Publish to Google Play
- ✅ Update and rebuild anytime

### Files to Remember:
- `build-apk-automated.bat` ← Use this first time
- `Build-APK-Auto.ps1` ← Use for advanced options
- `QUICK_BUILD.md` ← Quick reference
- `BUILD_AUTOMATION.md` ← Full guide

---

**Ready to build? Run:**
```batch
build-apk-automated.bat
```

**Good luck! 🚀**

---

© 2026 Developed by ENDY EDESON
