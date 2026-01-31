#!/bin/bash

# ============================================================
# HANDYMAN SERVICE FLUTTER APP - SETUP SCRIPT
# ============================================================
# This script sets up the Flutter app on your Windows computer
# and connects it to your local backend server.
# ============================================================

set -e

echo "============================================================"
echo "  HANDYMAN SERVICE FLUTTER APP - SETUP"
echo "============================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ============================================================
# STEP 1: Check Prerequisites
# ============================================================
echo "Step 1: Checking prerequisites..."
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed!"
    echo "Please install Flutter from: https://docs.flutter.dev/get-started/install/windows"
    exit 1
fi
print_status "Flutter is installed"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
print_status "Flutter version: $FLUTTER_VERSION"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed!"
    echo "Please install Git from: https://git-scm.com/download/win"
    exit 1
fi
print_status "Git is installed"

echo ""

# ============================================================
# STEP 2: Get Backend URL
# ============================================================
echo "Step 2: Configure Backend Connection..."
echo ""

# Get the local IP address
if command -v ipconfig &> /dev/null; then
    LOCAL_IP=$(ipconfig | grep -i "IPv4" | head -n 1 | awk '{print $NF}')
elif command -v hostname &> /dev/null; then
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

echo "Your local IP address appears to be: $LOCAL_IP"
echo ""
echo "Enter your backend server URL"
echo "(Press Enter for default: http://localhost:8000)"
echo ""
echo "Tips for backend URL:"
echo "  - For Android Emulator connecting to localhost: http://10.0.2.2:8000"
echo "  - For iOS Simulator connecting to localhost: http://localhost:8000"
echo "  - For Physical device on same network: http://$LOCAL_IP:8000"
echo ""
read -p "Backend URL: " BACKEND_URL

if [ -z "$BACKEND_URL" ]; then
    BACKEND_URL="http://localhost:8000"
fi

print_status "Backend URL set to: $BACKEND_URL"
echo ""

# ============================================================
# STEP 3: Get App Configuration
# ============================================================
echo "Step 3: Configure App Details..."
echo ""

read -p "Enter your app name (default: My Service App): " APP_NAME
APP_NAME=${APP_NAME:-"My Service App"}

read -p "Enter your app tagline (default: Quality Services at Your Doorstep): " APP_TAGLINE
APP_TAGLINE=${APP_TAGLINE:-"Quality Services at Your Doorstep"}

read -p "Enter your package name (default: com.yourcompany.yourapp): " PACKAGE_NAME
PACKAGE_NAME=${PACKAGE_NAME:-"com.yourcompany.yourapp"}

echo ""
print_status "App Name: $APP_NAME"
print_status "App Tagline: $APP_TAGLINE"
print_status "Package Name: $PACKAGE_NAME"
echo ""

# ============================================================
# STEP 4: Update Configuration Files
# ============================================================
echo "Step 4: Updating configuration files..."
echo ""

# Update app_config.dart
CONFIG_FILE="lib/app_config.dart"
if [ -f "$CONFIG_FILE" ]; then
    # Use sed to replace values (cross-platform compatible)
    sed -i "s|static const String appName = '.*';|static const String appName = '$APP_NAME';|g" "$CONFIG_FILE"
    sed -i "s|static const String appTagLine = '.*';|static const String appTagLine = '$APP_TAGLINE';|g" "$CONFIG_FILE"
    sed -i "s|static const String domainUrl = '.*';|static const String domainUrl = '$BACKEND_URL';|g" "$CONFIG_FILE"
    sed -i "s|static const String androidPackageName = '.*';|static const String androidPackageName = '$PACKAGE_NAME';|g" "$CONFIG_FILE"
    sed -i "s|static const String iosBundleId = '.*';|static const String iosBundleId = '$PACKAGE_NAME';|g" "$CONFIG_FILE"
    print_status "Updated lib/app_config.dart"
else
    print_error "Configuration file not found: $CONFIG_FILE"
fi

# Update Android build.gradle
BUILD_GRADLE="android/app/build.gradle"
if [ -f "$BUILD_GRADLE" ]; then
    sed -i "s|namespace \".*\"|namespace \"$PACKAGE_NAME\"|g" "$BUILD_GRADLE"
    sed -i "s|applicationId '.*'|applicationId '$PACKAGE_NAME'|g" "$BUILD_GRADLE"
    print_status "Updated android/app/build.gradle"
fi

# Update AndroidManifest.xml
MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST" ]; then
    sed -i "s|android:label=\".*\"|android:label=\"$APP_NAME\"|g" "$MANIFEST"
    print_status "Updated AndroidManifest.xml"
fi

echo ""

# ============================================================
# STEP 5: Install Flutter Dependencies
# ============================================================
echo "Step 5: Installing Flutter dependencies..."
echo ""

flutter pub get
print_status "Flutter dependencies installed"
echo ""

# ============================================================
# STEP 6: Clean and Build
# ============================================================
echo "Step 6: Cleaning project..."
echo ""

flutter clean
flutter pub get
print_status "Project cleaned"
echo ""

# ============================================================
# STEP 7: Run Build Runner (for code generation)
# ============================================================
echo "Step 7: Running code generation..."
echo ""

flutter packages pub run build_runner build --delete-conflicting-outputs 2>/dev/null || true
print_status "Code generation complete"
echo ""

# ============================================================
# SETUP COMPLETE
# ============================================================
echo "============================================================"
echo -e "${GREEN}  SETUP COMPLETE!${NC}"
echo "============================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Place your app logo at: assets/app_logo.png"
echo "   (512x512 PNG recommended)"
echo ""
echo "2. Set up Firebase:"
echo "   - Go to https://console.firebase.google.com"
echo "   - Create a new project"
echo "   - Add Android app with package: $PACKAGE_NAME"
echo "   - Download google-services.json to android/app/"
echo ""
echo "3. Update android/key.properties with your signing key"
echo ""
echo "4. Make sure your backend is running at: $BACKEND_URL"
echo ""
echo "5. Run the app:"
echo "   flutter run"
echo ""
echo "============================================================"
echo ""
