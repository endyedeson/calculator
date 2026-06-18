#!/usr/bin/env node

/**
 * ENDY EDESON Calculator - Automated APK Build Script
 * This script automates the entire process of building an Android APK
 */

const { execSync, spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

// Logging functions
const log = {
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  error: (msg) => console.error(`${colors.red}✗${colors.reset} ${msg}`),
  info: (msg) => console.log(`${colors.blue}ℹ${colors.reset} ${msg}`),
  warn: (msg) => console.warn(`${colors.yellow}⚠${colors.reset} ${msg}`),
  header: (msg) => console.log(`\n${colors.cyan}${colors.bright}${msg}${colors.reset}\n`),
  section: (msg) => console.log(`\n${colors.bright}${msg}${colors.reset}`)
};

// Config
const CONFIG = {
  appName: 'ENDY EDESON Calculator',
  packageName: 'com.endyedeson.calculator',
  projectDir: process.cwd()
};

// Banner
const showBanner = () => {
  log.header(`╔════════════════════════════════════════════════════╗
║  ENDY EDESON Calculator - Android APK Builder      ║
║  Automated Build & Installation                    ║
╚════════════════════════════════════════════════════╝`);
};

// Check if command exists
const commandExists = (command) => {
  try {
    execSync(`where ${command}`, { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
};

// Check prerequisites
const checkPrerequisites = () => {
  log.header('Checking Prerequisites...');

  const prerequisites = [
    { name: 'Node.js', command: 'node', getVersion: () => execSync('node --version').toString().trim() },
    { name: 'npm', command: 'npm', getVersion: () => execSync('npm --version').toString().trim() },
    { name: 'Cordova (optional)', command: 'cordova', optional: true }
  ];

  let allGood = true;
  prerequisites.forEach(({ name, command, optional, getVersion }) => {
    if (commandExists(command)) {
      const version = getVersion ? getVersion() : '';
      log.success(`${name} found ${version}`);
    } else {
      if (optional) {
        log.warn(`${name} not found (will be installed via npm)`);
      } else {
        log.error(`${name} NOT found. Install from: https://nodejs.org/`);
        allGood = false;
      }
    }
  });

  return allGood;
};

// Run command and capture output
const runCommand = (command, args = [], options = {}) => {
  return new Promise((resolve, reject) => {
    const isWindows = os.platform() === 'win32';
    const cmd = isWindows ? `${command}.cmd` : command;

    const child = spawn(cmd, args, {
      stdio: 'inherit',
      shell: true,
      ...options
    });

    child.on('close', (code) => {
      if (code === 0) {
        resolve(code);
      } else {
        reject(new Error(`Command failed with code ${code}`));
      }
    });

    child.on('error', (err) => {
      reject(err);
    });
  });
};

// Install dependencies
const installDependencies = async () => {
  log.section('Step 1: Installing NPM Dependencies...');
  try {
    await runCommand('npm', ['install']);
    log.success('NPM dependencies installed');
    return true;
  } catch (err) {
    log.error(`Failed to install dependencies: ${err.message}`);
    return false;
  }
};

// Install Cordova
const installCordova = async () => {
  log.section('Step 2: Installing Apache Cordova...');
  try {
    await runCommand('npm', ['install', '-g', 'cordova']);
    log.success('Cordova installed globally');
    return true;
  } catch (err) {
    log.error(`Failed to install Cordova: ${err.message}`);
    return false;
  }
};

// Check if Android SDK is installed
const checkAndroidSDK = () => {
  log.section('Step 3: Checking Android SDK Setup...');
  
  const androidHome = process.env.ANDROID_HOME || 
                     process.env.ANDROID_SDK_ROOT ||
                     'C:\\Android\\sdk'; // Default Android Studio location on Windows

  if (fs.existsSync(androidHome)) {
    log.success(`Android SDK found at: ${androidHome}`);
    return true;
  } else {
    log.warn(`Android SDK not found at: ${androidHome}`);
    log.info('You may need to set ANDROID_HOME environment variable');
    log.info('Android SDK path examples:');
    log.info('  Windows: C:\\Android\\sdk');
    log.info('  Linux: ~/Android/Sdk');
    log.info('  macOS: ~/Library/Android/sdk');
    return false;
  }
};

// Build APK
const buildAPK = async (isRelease = false) => {
  const buildType = isRelease ? 'Release' : 'Debug';
  const args = ['build', 'android'];
  
  if (isRelease) {
    args.push('--release');
  }

  log.section(`Step 4: Building ${buildType} APK...`);
  log.info('This may take several minutes on first build...');

  try {
    await runCommand('cordova', args);
    log.success(`${buildType} APK build completed`);
    return true;
  } catch (err) {
    log.error(`Failed to build APK: ${err.message}`);
    return false;
  }
};

// Find APK file
const findAPK = (isRelease = false) => {
  const debugPath = path.join(CONFIG.projectDir, 'platforms', 'android', 'app', 'build', 'outputs', 'apk', 'debug', 'app-debug.apk');
  const releasePath = path.join(CONFIG.projectDir, 'platforms', 'android', 'app', 'build', 'outputs', 'apk', 'release', 'app-release.apk');
  
  const targetPath = isRelease ? releasePath : debugPath;
  
  if (fs.existsSync(targetPath)) {
    const stats = fs.statSync(targetPath);
    const sizeMB = (stats.size / 1024 / 1024).toFixed(2);
    return { path: targetPath, size: sizeMB };
  }

  return null;
};

// Show installation instructions
const showInstallInstructions = (apkInfo) => {
  log.section('Installation Methods');
  
  log.info('Method 1: Direct File Installation');
  console.log(`  1. Transfer APK: ${apkInfo.path}`);
  console.log(`  2. Send to Android device (email, USB, cloud)`);
  console.log(`  3. Open file manager on phone`);
  console.log(`  4. Tap the APK and confirm installation\n`);
  
  log.info('Method 2: ADB (Command Line)');
  console.log(`  1. Connect Android device via USB`);
  console.log(`  2. Enable USB Debugging in Settings → Developer Options`);
  console.log(`  3. Run: adb install "${apkInfo.path}"\n`);
  
  log.info('Method 3: Android Emulator');
  console.log(`  1. Start emulator from Android Studio`);
  console.log(`  2. Drag APK onto emulator window (auto-installs)`);
  console.log(`  3. Or: adb install "${apkInfo.path}"\n`);
};

// Main execution
const main = async () => {
  showBanner();

  // Check prerequisites
  if (!checkPrerequisites()) {
    log.error('Missing required prerequisites. Please install Node.js first.');
    process.exit(1);
  }

  console.log('\n');

  // Install dependencies
  if (!await installDependencies()) {
    log.error('Installation failed. Exiting.');
    process.exit(1);
  }

  // Install Cordova
  if (!await installCordova()) {
    log.error('Cordova installation failed. Exiting.');
    process.exit(1);
  }

  // Check Android SDK
  const androidSDKFound = checkAndroidSDK();
  if (!androidSDKFound) {
    log.warn('Continuing anyway - you may encounter errors during build.');
  }

  console.log('\n');

  // Build APK
  if (!await buildAPK(false)) {
    log.error('APK build failed.');
    log.info('Troubleshooting steps:');
    log.info('1. Ensure Android SDK is installed and ANDROID_HOME is set');
    log.info('2. Check that you have 5+ GB free disk space');
    log.info('3. Try running: cordova clean android');
    log.info('4. Then retry: cordova build android');
    process.exit(1);
  }

  // Show results
  log.section('Build Complete! 🎉');

  const apkInfo = findAPK();
  if (apkInfo) {
    log.success(`APK successfully generated!`);
    console.log(`  📁 Location: ${apkInfo.path}`);
    console.log(`  📦 Size: ${apkInfo.size} MB\n`);

    log.section('Next Steps');
    console.log(`  1. Install APK on device or emulator`);
    console.log(`  2. Test calculator functionality`);
    console.log(`  3. For Play Store release: cordova build android --release\n`);

    showInstallInstructions(apkInfo);

    log.header('Build Status: SUCCESS ✓');
  } else {
    log.warn('APK file not found. Build may have failed.');
    process.exit(1);
  }
};

// Run main with error handling
main().catch(err => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});
