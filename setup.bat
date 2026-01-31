@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo   HANDYMAN SERVICE FLUTTER APP - SETUP (Windows)
echo ============================================================
echo.

REM ============================================================
REM STEP 1: Check Prerequisites
REM ============================================================
echo Step 1: Checking prerequisites...
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed!
    echo Please install Flutter from: https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)
echo [OK] Flutter is installed

REM Check Flutter doctor
echo.
echo Running Flutter doctor...
flutter doctor
echo.

REM ============================================================
REM STEP 2: Get Backend URL
REM ============================================================
echo Step 2: Configure Backend Connection...
echo.
echo Tips for backend URL:
echo   - For Android Emulator connecting to localhost: http://10.0.2.2:8000
echo   - For iOS Simulator connecting to localhost: http://localhost:8000
echo   - For Physical device on same network: http://YOUR_PC_IP:8000
echo.
set /p BACKEND_URL="Enter backend URL (default: http://localhost:8000): "
if "!BACKEND_URL!"=="" set BACKEND_URL=http://localhost:8000
echo [OK] Backend URL: !BACKEND_URL!
echo.

REM ============================================================
REM STEP 3: Get App Configuration
REM ============================================================
echo Step 3: Configure App Details...
echo.
set /p APP_NAME="Enter app name (default: My Service App): "
if "!APP_NAME!"=="" set APP_NAME=My Service App

set /p PACKAGE_NAME="Enter package name (default: com.yourcompany.yourapp): "
if "!PACKAGE_NAME!"=="" set PACKAGE_NAME=com.yourcompany.yourapp

echo.
echo [OK] App Name: !APP_NAME!
echo [OK] Package Name: !PACKAGE_NAME!
echo.

REM ============================================================
REM STEP 4: Install Flutter Dependencies
REM ============================================================
echo Step 4: Installing Flutter dependencies...
echo.
call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

REM ============================================================
REM STEP 5: Clean Project
REM ============================================================
echo Step 5: Cleaning project...
echo.
call flutter clean
call flutter pub get
echo [OK] Project cleaned
echo.

REM ============================================================
REM STEP 6: Run Build Runner
REM ============================================================
echo Step 6: Running code generation (this may take a while)...
echo.
call flutter packages pub run build_runner build --delete-conflicting-outputs 2>nul
echo [OK] Code generation complete
echo.

REM ============================================================
REM SETUP COMPLETE
REM ============================================================
echo ============================================================
echo   SETUP COMPLETE!
echo ============================================================
echo.
echo IMPORTANT: You need to manually update these files:
echo.
echo 1. Edit lib/app_config.dart:
echo    - Set appName = '!APP_NAME!'
echo    - Set domainUrl = '!BACKEND_URL!'
echo    - Set androidPackageName = '!PACKAGE_NAME!'
echo    - Set iosBundleId = '!PACKAGE_NAME!'
echo.
echo 2. Place your app logo at: assets/app_logo.png
echo    (512x512 PNG recommended)
echo.
echo 3. Set up Firebase:
echo    - Go to https://console.firebase.google.com
echo    - Create a new project
echo    - Add Android app with package: !PACKAGE_NAME!
echo    - Download google-services.json to android/app/
echo.
echo 4. Update android/key.properties with your signing key
echo.
echo 5. Make sure your backend is running at: !BACKEND_URL!
echo.
echo 6. Run the app: flutter run
echo.
echo ============================================================
echo.
pause
