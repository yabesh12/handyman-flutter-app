# Handyman Service - Flutter User App Template

A Flutter-based mobile application template for on-demand home services. This template is ready to be customized for your own service booking platform.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher) - [Install Flutter](https://docs.flutter.dev/get-started/install/windows)
- **Android Studio** - [Download](https://developer.android.com/studio)
- **Git** - [Download](https://git-scm.com/download/win)
- **Java JDK 21** - Required for Android builds

## Quick Setup

### Windows Users

1. **Run the setup script:**
   ```bash
   # Using Git Bash
   ./setup.sh

   # OR using Command Prompt
   setup.bat
   ```

2. **Follow the prompts** to configure your app name, backend URL, and package name.

### Manual Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure the app** by editing `lib/app_config.dart`:
   ```dart
   static const String appName = 'Your App Name';
   static const String appTagLine = 'Your Tagline';
   static const String domainUrl = 'http://YOUR_BACKEND_URL';
   static const String androidPackageName = 'com.yourcompany.yourapp';
   ```

3. **Add your app logo:**
   - Place your logo at `assets/app_logo.png` (512x512 PNG recommended)

4. **Update Android configuration:**
   - Edit `android/app/build.gradle` - update `namespace` and `applicationId`
   - Edit `android/app/src/main/AndroidManifest.xml` - update `android:label`
   - Rename the kotlin package folder to match your package name

5. **Set up Firebase:**
   - Create a project at [Firebase Console](https://console.firebase.google.com)
   - Add an Android app with your package name
   - Download `google-services.json` to `android/app/`
   - Add an iOS app and download `GoogleService-Info.plist` to `ios/Runner/`

6. **Generate signing key (for release builds):**
   ```bash
   keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias your-key-alias
   ```
   Update `android/key.properties` with your keystore details.

## Connecting to Backend

### For Development (Localhost Backend)

| Platform | Backend URL |
|----------|-------------|
| Android Emulator | `http://10.0.2.2:8000` |
| iOS Simulator | `http://localhost:8000` |
| Physical Device | `http://YOUR_PC_IP:8000` |

**Note:** Ensure your backend server allows connections from the app by configuring CORS properly.

### For Production

Update `lib/app_config.dart` with your production server URL:
```dart
static const String domainUrl = 'https://api.yourproductionserver.com';
```

## Running the App

```bash
# Run in debug mode
flutter run

# Build APK for Android
flutter build apk --release

# Build for iOS (requires macOS)
flutter build ios --release
```

## Project Structure

```
lib/
├── app_config.dart      # Main configuration file (customize this!)
├── main.dart            # App entry point
├── model/               # Data models
├── network/             # API services
├── screens/             # UI screens
├── store/               # State management (MobX)
├── utils/               # Utilities and constants
└── component/           # Reusable widgets
```

## Configuration Files

| File | Purpose |
|------|---------|
| `lib/app_config.dart` | Main app configuration (name, URLs, etc.) |
| `android/app/build.gradle` | Android build settings & package name |
| `android/app/google-services.json` | Firebase config for Android |
| `android/key.properties` | Signing key configuration |
| `ios/Runner/GoogleService-Info.plist` | Firebase config for iOS |
| `pubspec.yaml` | Flutter dependencies |

## Customization Checklist

- [ ] Update `lib/app_config.dart` with your app details
- [ ] Replace `assets/app_logo.png` with your logo
- [ ] Update package name in `android/app/build.gradle`
- [ ] Update app label in `AndroidManifest.xml`
- [ ] Set up Firebase and add `google-services.json`
- [ ] Generate and configure signing keys
- [ ] Update Terms, Privacy Policy, and Support URLs
- [ ] Configure payment gateways (if needed)
- [ ] Update Google Maps API key in AndroidManifest.xml

## Troubleshooting

### Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Backend Connection Issues

1. Ensure backend is running
2. Check the URL in `lib/app_config.dart`
3. For physical devices, ensure they're on the same network
4. Check backend CORS configuration

### Firebase Issues

1. Verify `google-services.json` is in `android/app/`
2. Ensure package name matches Firebase console
3. Run `flutter clean` after adding Firebase files

## Support

For issues with this template, please check:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview)

## License

This is a template based on the Handyman Service app. Please ensure you have the appropriate licenses for commercial use.
