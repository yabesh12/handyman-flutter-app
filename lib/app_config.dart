/// ============================================================
/// AC CHILL - APP CONFIGURATION FILE
/// ============================================================
/// This file contains all configurable values for your app.
/// Update these values before building your app.
/// ============================================================

class AppConfig {
  AppConfig._();

  // ============================================================
  // APP BRANDING
  // ============================================================

  /// Your app name (displayed in the app)
  static const String appName = 'AC Chill';

  /// App tagline (displayed on splash/home screen)
  static const String appTagLine = 'Cool Comfort at Your Doorstep';

  /// App logo path (place your logo in assets folder)
  static const String appLogo = 'assets/app_logo.png';

  // ============================================================
  // BACKEND CONFIGURATION
  // ============================================================

  /// Your backend server URL (without trailing slash)
  /// For local development: http://10.0.2.2:8000 (Android emulator)
  /// For local development: http://localhost:8000 (iOS simulator)
  /// For physical device: http://YOUR_PC_IP:8000
  static const String domainUrl = 'https://acchill.com';

  /// API base URL (usually domainUrl + /api/)
  static const String baseUrl = '$domainUrl/api/';

  // ============================================================
  // PACKAGE NAMES (for app stores)
  // ============================================================

  /// Android package name (must match build.gradle)
  static const String androidPackageName = 'com.acchill.app';

  /// iOS bundle ID (must match Xcode project)
  static const String iosBundleId = 'com.acchill.app';

  /// Provider app package name (for "Become a Provider" feature)
  static const String providerPackageName = 'com.acchill.provider';

  // ============================================================
  // APP STORE LINKS (update after publishing)
  // ============================================================

  /// iOS App Store link for this app
  static const String iosAppStoreLink = '';

  /// iOS App Store link for Provider app
  static const String iosProviderAppStoreLink = '';

  // ============================================================
  // SUPPORT & LEGAL
  // ============================================================

  /// Terms & Conditions URL
  static const String termsConditionUrl = 'https://acchill.com/terms';

  /// Privacy Policy URL
  static const String privacyPolicyUrl = 'https://acchill.com/privacy';

  /// Help & Support URL
  static const String helpSupportUrl = 'https://acchill.com/support';

  /// Refund Policy URL
  static const String refundPolicyUrl = 'https://acchill.com/refund';

  /// Support email address
  static const String supportEmail = 'support@acchill.com';

  /// Helpline phone number
  static const String helplineNumber = '+1234567890';

  // ============================================================
  // DEFAULT COUNTRY (for phone number input)
  // ============================================================

  static const String defaultCountryCode = 'US';
  static const String defaultPhoneCode = '1';
  static const String defaultCountryName = 'United States';

  // ============================================================
  // DEMO CREDENTIALS (remove in production)
  // ============================================================

  /// Demo email for testing (leave empty to disable)
  static const String demoEmail = '';

  /// Demo password for testing (leave empty to disable)
  static const String demoPassword = '';
}
