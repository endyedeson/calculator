# Android APK Build Guide - ENDY EDESON Calculator

## 📱 Quick Start: Building the Android APK

This guide will help you convert the web calculator into an installable Android app.

### Prerequisites
- **Android SDK** (download from Android Studio)
- **Java Development Kit (JDK)** - Java 8 or higher
- **Gradle** - Build system for Android
- **Apache Cordova** or **Capacitor** - Web app wrapper
- **Node.js & npm** - JavaScript runtime

### Option 1: Using Capacitor (Recommended - Easiest)

#### Step 1: Install Capacitor
```bash
npm install -g @capacitor/cli
npm install @capacitor/core @capacitor/android
```

#### Step 2: Initialize Capacitor
```bash
cd calculator
npx cap init
# Answer prompts:
# App name: ENDY EDESON Calculator
# App Package: com.endyedeson.calculator
# Web dir: .
```

#### Step 3: Add Android Platform
```bash
npx cap add android
```

#### Step 4: Build Web Assets
```bash
# Ensure index.html, style.css, script.js are in the project root
npx cap sync android
```

#### Step 5: Open in Android Studio
```bash
npx cap open android
```
- Android Studio will open automatically
- Build → Build Bundle(s) / APK(s) → Build APK(s)
- APK will be generated in: `android/app/build/outputs/apk/debug/app-debug.apk`

#### Step 6: For Production (Signed Release APK)
```bash
# Build release in Android Studio
# Menu: Build → Build Bundle(s) / APK(s) → Build APK(s)
# Select "Release" variant
# Sign with your keystore
# Output: `android/app/build/outputs/apk/release/app-release.apk`
```

---

### Option 2: Using Apache Cordova (Alternative)

#### Step 1: Install Cordova
```bash
npm install -g cordova
```

#### Step 2: Create Cordova Project
```bash
cordova create calculator-cordova com.endyedeson.calculator "ENDY EDESON Calculator"
cd calculator-cordova
```

#### Step 3: Copy Your Files
```bash
# Copy index.html, style.css, script.js to www/ folder
cp ../calculator/{index.html,style.css,script.js} www/
```

#### Step 4: Add Android Platform
```bash
cordova platform add android
```

#### Step 5: Build APK
```bash
# Debug APK
cordova build android

# Release APK (sign with keystore)
cordova build android --release
```

Output location: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

---

### Option 3: Manual Android Studio Setup (Most Control)

1. **Create New Android Project** in Android Studio
2. **Choose "Empty Activity"** template
3. **Configure Project**:
   - Name: ENDY EDESON Calculator
   - Package name: com.endyedeson.calculator
   - SDK: API 21+ (minimum)
   - Language: Java/Kotlin

4. **Add WebView**:
   - Modify `activity_main.xml` with WebView element
   - Load local files via WebView

5. **Copy Web Files** to `assets/` folder

6. **Build and Sign** the APK

---

## 📦 Generated APK Details

- **App Name**: ENDY EDESON Calculator
- **Package ID**: com.endyedeson.calculator
- **Min SDK**: API 21 (Android 5.0)
- **Target SDK**: API 31 (Android 12)
- **File Format**: .apk (installable on Android devices)

---

## 📥 Installation

### On Android Device

#### Method 1: Direct Installation
1. Transfer APK to Android device
2. Enable "Unknown Sources" in Settings → Security
3. Open file manager and tap the APK
4. Follow installation prompts

#### Method 2: Using Android Studio
```bash
adb install app-debug.apk
```

#### Method 3: Google Play Store
1. Create developer account ($25 one-time fee)
2. Sign APK with release keystore
3. Upload to Google Play Console
4. Fill in store listing details
5. Submit for review

---

## 🔑 Creating a Keystore for Release APK

```bash
# Generate keystore (one-time)
keytool -genkey -v -keystore my-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Sign APK with Gradle (in Android Studio build.gradle)
# Add signing config and build types
```

---

## 📊 APK File Structure

```
app-debug.apk (or app-release.apk)
├── AndroidManifest.xml       # App configuration
├── classes.dex              # Compiled code
├── resources.arsc           # Resources
└── assets/
    ├── index.html
    ├── style.css
    ├── script.js
    └── ...
```

---

## 🧪 Testing the APK

### On Emulator
1. Open Android Studio
2. Tools → AVD Manager → Create Virtual Device
3. Launch emulator
4. Drag and drop APK onto emulator

### On Physical Device
1. Enable Developer Mode (tap Build Number 7 times)
2. Enable USB Debugging
3. Connect via USB
4. Run: `adb install app-debug.apk`

---

## 📱 App Features in Android

✅ Touch-optimized interface
✅ Full screen mode
✅ Hardware acceleration
✅ Portrait orientation locked
✅ History persistence (LocalStorage)
✅ Sound effects support
✅ Back button handling

---

## 🛠️ Troubleshooting

### APK Won't Install
- Check Android version (min API 21)
- Verify app isn't already installed
- Try installing on emulator first

### App Force Closes
- Check LogCat in Android Studio
- Verify all files are in assets folder
- Check Android manifest permissions

### Performance Issues
- Enable hardware acceleration in config
- Optimize images
- Minimize JavaScript bundle

### White Screen
- Check if index.html loads
- Verify correct file paths
- Check browser console for errors

---

## 📈 App Size Optimization

Default APK size: ~10-15 MB

To reduce:
1. Remove unused JavaScript
2. Optimize images
3. Enable code minification
4. Use ProGuard/R8 obfuscation

---

## 🚀 Publishing to Google Play

1. **Create Developer Account**: developer.google.com
2. **Prepare Assets**:
   - App icon (512x512 PNG)
   - Screenshots (up to 8)
   - Feature graphic (1024x500 PNG)
   - Description & privacy policy
3. **Upload APK/Bundle**
4. **Set Content Rating**
5. **Configure Pricing**
6. **Submit for Review** (24-72 hours)

---

## 📝 Final Checklist

- [ ] App runs on Android emulator
- [ ] Touch interface works correctly
- [ ] History saves and loads
- [ ] All buttons responsive
- [ ] Sound effects work
- [ ] No console errors
- [ ] Privacy policy updated
- [ ] APK signed (for release)
- [ ] Icon/splash screen configured

---

## 📞 Support Resources

- **Capacitor Docs**: https://capacitorjs.com
- **Cordova Docs**: https://cordova.apache.org
- **Android Docs**: https://developer.android.com
- **Google Play Console**: https://play.google.com/console

---

**Build Command Summary:**

```bash
# Capacitor
npx cap init
npx cap add android
npx cap sync
npx cap open android

# Cordova
cordova create project-name com.package app-name
cordova platform add android
cordova build android
```

---

Generated for: ENDY EDESON Calculator
Date: 2026-06-02
Package: com.endyedeson.calculator
