#!/bin/bash

# =========================================================
# ENDY EDESON Calculator - Android APK Builder
# Automated build script for Linux/macOS
# =========================================================

echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║  ENDY EDESON Calculator - Android APK Builder      ║"
echo "║  Building installable APK...                       ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}[ERROR] Node.js is not installed${NC}"
    echo "Download from: https://nodejs.org/"
    exit 1
fi

# Check if npx is available
if ! command -v npx &> /dev/null; then
    echo -e "${RED}[ERROR] NPX is not available${NC}"
    echo "Please ensure Node.js 8.2+ is installed"
    exit 1
fi

echo -e "${GREEN}[✓] Node.js and npm verified${NC}"
node --version
npm --version
echo ""

# Option menu
echo "Choose build option:"
echo "1 - Install Capacitor and build for Android (Recommended)"
echo "2 - Install Cordova and build for Android"
echo "3 - Quick guide to use Android Studio"
echo "4 - Exit"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}[*] Installing dependencies...${NC}"
        npm install
        
        echo -e "${YELLOW}[*] Installing Capacitor CLI globally...${NC}"
        npm install -g @capacitor/cli
        
        echo -e "${YELLOW}[*] Installing Capacitor core packages...${NC}"
        npm install @capacitor/core @capacitor/android
        
        echo -e "${YELLOW}[*] Initializing Capacitor project...${NC}"
        npx cap init "ENDY EDESON Calculator" "com.endyedeson.calculator"
        
        echo -e "${YELLOW}[*] Adding Android platform...${NC}"
        npx cap add android
        
        echo -e "${YELLOW}[*] Syncing web assets...${NC}"
        npx cap sync
        
        echo ""
        echo "╔════════════════════════════════════════════════════╗"
        echo "║  Next Steps:                                       ║"
        echo "║  1. Run: npx cap open android                      ║"
        echo "║  2. In Android Studio:                             ║"
        echo "║     Build → Build Bundle(s)/APK(s) → Build APK(s) ║"
        echo "║  3. APK location:                                  ║"
        echo "║     android/app/build/outputs/apk/debug/          ║"
        echo "╚════════════════════════════════════════════════════╝"
        echo ""
        ;;
    
    2)
        echo ""
        echo -e "${YELLOW}[*] Installing Cordova globally...${NC}"
        sudo npm install -g cordova
        
        echo -e "${YELLOW}[*] Creating Cordova project...${NC}"
        cordova create calculator-cordova com.endyedeson.calculator "ENDY EDESON Calculator"
        cd calculator-cordova
        
        echo -e "${YELLOW}[*] Adding Android platform...${NC}"
        cordova platform add android
        
        echo -e "${YELLOW}[*] Building APK (debug)...${NC}"
        cordova build android
        
        echo ""
        echo "╔════════════════════════════════════════════════════╗"
        echo "║  Build Complete!                                   ║"
        echo "║  APK location:                                     ║"
        echo "║  platforms/android/app/build/outputs/apk/debug/   ║"
        echo "║                                                    ║"
        echo "║  To install on device:                             ║"
        echo "║  adb install app-debug.apk                         ║"
        echo "╚════════════════════════════════════════════════════╝"
        echo ""
        ;;
    
    3)
        echo ""
        echo "╔════════════════════════════════════════════════════╗"
        echo "║  Android Studio Manual Setup                       ║"
        echo "╚════════════════════════════════════════════════════╝"
        echo ""
        echo "1. Download Android Studio:"
        echo "   https://developer.android.com/studio"
        echo ""
        echo "2. Create New Project:"
        echo "   - Choose 'Empty Activity'"
        echo "   - Package name: com.endyedeson.calculator"
        echo "   - Min SDK: API 21"
        echo ""
        echo "3. Configure WebView:"
        echo "   - Add WebView to activity_main.xml"
        echo "   - Load local HTML files"
        echo ""
        echo "4. Copy Web Files to Assets:"
        echo "   - app/src/main/assets/"
        echo "   - index.html, style.css, script.js"
        echo ""
        echo "5. Build and Sign APK:"
        echo "   - Build → Build Bundle(s)/APK(s) → Build APK(s)"
        echo ""
        echo "For complete guide, see: ANDROID_BUILD_GUIDE.md"
        echo ""
        ;;
    
    4)
        echo "Exiting..."
        exit 0
        ;;
    
    *)
        echo -e "${RED}[ERROR] Invalid choice${NC}"
        exit 1
        ;;
esac
