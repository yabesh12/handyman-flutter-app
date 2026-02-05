/// ============================================================
/// UX SERVE - APP CONFIGURATION FILE
/// ============================================================
/// AC Service Booking App - Chennai, South India
/// ============================================================

class AppConfig {
  AppConfig._();

  // ============================================================
  // APP BRANDING
  // ============================================================

  static const String appName = 'UX Serve';
  static const String appTagLine = 'Cool Comfort at Your Doorstep';
  static const String appLogo = 'assets/app_logo.png';

  // ============================================================
  // BACKEND CONFIGURATION
  // ============================================================

  static const String domainUrl = 'https://acchill.com';
  static const String baseUrl = '$domainUrl/api/';

  // ============================================================
  // PACKAGE NAMES
  // ============================================================

  static const String androidPackageName = 'com.acchill.app';
  static const String iosBundleId = 'com.acchill.app';
  static const String providerPackageName = 'com.acchill.provider';

  // ============================================================
  // APP STORE LINKS
  // ============================================================

  static const String iosAppStoreLink = '';
  static const String iosProviderAppStoreLink = '';

  // ============================================================
  // SUPPORT & LEGAL
  // ============================================================

  static const String termsConditionUrl = 'https://acchill.com/terms';
  static const String privacyPolicyUrl = 'https://acchill.com/privacy';
  static const String helpSupportUrl = 'https://acchill.com/support';
  static const String refundPolicyUrl = 'https://acchill.com/refund';
  static const String supportEmail = 'support@acchill.com';
  static const String helplineNumber = '+919876543210';

  // ============================================================
  // DEFAULT COUNTRY - Chennai, South India
  // ============================================================

  static const String defaultCountryCode = 'IN';
  static const String defaultPhoneCode = '91';
  static const String defaultCountryName = 'India';

  // ============================================================
  // CURRENCY - INR Only
  // ============================================================

  static const String defaultCurrencyCode = 'INR';
  static const String defaultCurrencySymbol = '\u20B9';
  static const String defaultCurrencyName = 'Indian Rupee';

  // ============================================================
  // DEMO CREDENTIALS (empty = disabled)
  // ============================================================

  static const String demoEmail = '';
  static const String demoPassword = '';
}
