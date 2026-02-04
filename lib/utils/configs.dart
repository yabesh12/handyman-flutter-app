import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:booking_system_flutter/app_config.dart';

const APP_NAME = AppConfig.appName;
const APP_NAME_TAG_LINE = AppConfig.appTagLine;
// AC Chill Theme - Cool Blue (#1E88E5)
var defaultPrimaryColor = Color(0xFF1E88E5);

// Don't add slash at the end of the url

// Backend Server URL - Configure in lib/app_config.dart
const DOMAIN_URL = AppConfig.domainUrl;
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';

/// Provider App package name - Configure in lib/app_config.dart
const PROVIDER_PACKAGE_NAME = AppConfig.providerPackageName;
const IOS_LINK_FOR_PARTNER = AppConfig.iosProviderAppStoreLink;

const IOS_LINK_FOR_USER = AppConfig.iosAppStoreLink;

const DASHBOARD_AUTO_SLIDER_SECOND = 5;
const OTP_TEXT_FIELD_LENGTH = 6;

const TERMS_CONDITION_URL = AppConfig.termsConditionUrl;
const PRIVACY_POLICY_URL = AppConfig.privacyPolicyUrl;
const HELP_AND_SUPPORT_URL = AppConfig.helpSupportUrl;
const REFUND_POLICY_URL = AppConfig.refundPolicyUrl;
const INQUIRY_SUPPORT_EMAIL = AppConfig.supportEmail;

/// Helpline number for contact
const HELP_LINE_NUMBER = AppConfig.helplineNumber;

//Airtel Money Payments
///It Supports ["UGX", "NGN", "TZS", "KES", "RWF", "ZMW", "CFA", "XOF", "XAF", "CDF", "USD", "XAF", "SCR", "MGA", "MWK"]
const AIRTEL_CURRENCY_CODE = "MWK";
const AIRTEL_COUNTRY_CODE = "MW";
const AIRTEL_TEST_BASE_URL = 'https://openapiuat.airtel.africa/'; //Test Url
const AIRTEL_LIVE_BASE_URL = 'https://openapi.airtel.africa/'; // Live Url

/// PAYSTACK PAYMENT DETAIL
const PAYSTACK_CURRENCY_CODE = 'NGN';

/// Nigeria Currency

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';

/// RAZORPAY PAYMENT DETAIL
const RAZORPAY_CURRENCY_CODE = 'INR';

/// PAYPAL PAYMENT DETAIL
const PAYPAL_CURRENCY_CODE = 'USD';

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

DateTime todayDate = DateTime(2022, 8, 24);

Country defaultCountry() {
  return Country(
    phoneCode: AppConfig.defaultPhoneCode,
    countryCode: AppConfig.defaultCountryCode,
    e164Sc: int.tryParse(AppConfig.defaultPhoneCode) ?? 1,
    geographic: true,
    level: 1,
    name: AppConfig.defaultCountryName,
    example: '9123456789',
    displayName: '${AppConfig.defaultCountryName} (${AppConfig.defaultCountryCode}) [+${AppConfig.defaultPhoneCode}]',
    displayNameNoCountryCode: '${AppConfig.defaultCountryName} (${AppConfig.defaultCountryCode})',
    e164Key: '${AppConfig.defaultPhoneCode}-${AppConfig.defaultCountryCode}-0',
    fullExampleWithPlusSign: '+${AppConfig.defaultPhoneCode}9123456789',
  );
}

//Chat Module File Upload Configs
const chatFilesAllowedExtensions = [
  'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
  'pdf', 'txt', // Documents
  'mkv', 'mp4', // Video
  'mp3', // Audio
];

const max_acceptable_file_size = 5; //Size in Mb
