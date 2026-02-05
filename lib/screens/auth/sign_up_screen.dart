import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/selected_item_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/auth/email_otp_verification_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:country_picker/country_picker.dart';
// AC Chill - Firebase Auth removed
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final bool isOTPLogin;
  final String? uid;
  final int? tokenForOTPCredentials;

  SignUpScreen({Key? key, this.phoneNumber, this.isOTPLogin = false, this.countryCode, this.uid, this.tokenForOTPCredentials}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country selectedCountry = defaultCountry();

  // AC Chill - Simplified registration with full name
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  FocusNode fullNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  bool isAcceptedTc = false;

  bool isFirstTimeValidation = true;
  ValueNotifier _valueNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.phoneNumber != null) {
      selectedCountry = Country.parse(widget.countryCode.validate(value: selectedCountry.countryCode));

      mobileCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      passwordCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Logic
  String buildMobileNumber() {
    if (mobileCont.text.isEmpty) {
      return '';
    } else {
      return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
    }
  }

  Future<void> registerWithOTP() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      if (isAcceptedTc) {
        formKey.currentState!.save();
        appStore.setLoading(true);

        // AC Chill - Split full name into first and last name for OTP registration
        String fullName = fullNameCont.text.trim();
        String firstName = fullName.split(' ').first;
        String lastName = fullName.split(' ').length > 1
            ? fullName.split(' ').skip(1).join(' ')
            : '';

        UserData userResponse = UserData()
          ..username = widget.phoneNumber.validate().trim()
          ..loginType = LOGIN_TYPE_OTP
          ..contactNumber = buildMobileNumber()
          ..email = emailCont.text.trim()
          ..firstName = firstName
          ..lastName = lastName
          ..userType = USER_TYPE_USER
          ..uid = widget.uid.validate()
          ..password = widget.phoneNumber.validate().trim();

        // AC Chill - Firebase OTP credential linking disabled

        await createUsers(tempRegisterData: userResponse);
      }
    }
  }

  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: language.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),

      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
      },
    );
  }

  void registerUser() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// If Terms and condition is Accepted then only the user will be registered
      if (isAcceptedTc) {
        appStore.setLoading(true);

        // AC Chill - Split full name into first and last name
        String fullName = fullNameCont.text.trim();
        String firstName = fullName.split(' ').first;
        String lastName = fullName.split(' ').length > 1
            ? fullName.split(' ').skip(1).join(' ')
            : '';

        /// Create a temporary request to send
        /// AC Chill - Use email as username
        UserData tempRegisterData = UserData()
          ..contactNumber = buildMobileNumber()
          ..firstName = firstName
          ..lastName = lastName
          ..loginType = LOGIN_TYPE_USER
          ..userType = USER_TYPE_USER
          ..username = emailCont.text.trim()
          ..email = emailCont.text.trim()
          ..password = passwordCont.text.trim()
          ..address = addressCont.text.trim();

        createUsers(tempRegisterData: tempRegisterData);
      } else {
        toast(language.termsConditionsAccept);
      }
    } else {
      isFirstTimeValidation = false;
      setState(() {});
    }
  }

  Future<void> createUsers({required UserData tempRegisterData}) async {
    await createUser(tempRegisterData.toJson()).then((registerResponse) async {
      registerResponse.userData!.password = passwordCont.text.trim();

      appStore.setLoading(false);
      toast(registerResponse.message.validate());
      await appStore.setLoginType(tempRegisterData.loginType!);

      // AC Chill - Navigate to OTP verification screen
      bool? verified = await EmailOTPVerificationScreen(
        email: emailCont.text.trim(),
        isFromForgotPassword: false,
      ).launch(context);

      if (verified == true) {
        /// Back to sign in screen after email verification
        finish(context);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  //endregion

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      children: [
        (context.height() * 0.12).toInt().height,
        Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(16),
          child: ic_profile2.iconImage(color: Colors.white),
          decoration: boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
        ),
        16.height,
        Text(language.lblHelloUser, style: boldTextStyle(size: 22)).center(),
        16.height,
        Text(language.lblSignUpSubTitle, style: secondaryTextStyle(size: 14), textAlign: TextAlign.center).center().paddingSymmetric(horizontal: 32),
      ],
    );
  }

  Widget _buildFormWidget() {
    setState(() {});
    return Column(
      children: [
        32.height,
        // AC Chill - Full Name field (required)
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fullNameCont,
          focus: fullNameFocus,
          nextFocus: emailFocus,
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.fullName),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Email field (required)
        AppTextField(
          textFieldType: TextFieldType.EMAIL_ENHANCED,
          controller: emailCont,
          focus: emailFocus,
          errorThisFieldRequired: language.requiredText,
          nextFocus: passwordFocus,
          decoration: inputDecoration(context, labelText: language.hintEmailTxt),
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Password field (required)
        if (!widget.isOTPLogin)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: passwordCont,
                focus: passwordFocus,
                nextFocus: mobileFocus,
                obscureText: true,
                readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: language.hintPasswordTxt),
              ),
              16.height,
            ],
          ),
        // Mobile Number field (optional)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code ...
            Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _valueNotifier,
                  builder: (context, value, child) => Row(
                    children: [
                      Text(
                        "+${selectedCountry.phoneCode}",
                        style: primaryTextStyle(size: 12),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: textSecondaryColorGlobal,
                      )
                    ],
                  ).paddingOnly(left: 8),
                ),
              ),
            ).onTap(() => changeCountry()),
            10.width,
            // Mobile number text field...
            AppTextField(
              textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
              controller: mobileCont,
              focus: mobileFocus,
              errorThisFieldRequired: language.requiredText,
              nextFocus: addressFocus,
              isValidationRequired: false,
              decoration: inputDecoration(context, labelText: "${language.hintContactNumberTxt} (${language.notAvailable.toLowerCase()})").copyWith(
                hintText: '${language.lblExample}: ${selectedCountry.example}',
                hintStyle: secondaryTextStyle(),
              ),
              maxLength: 15,
              suffix: ic_calling.iconImage(size: 10).paddingAll(14),
            ).expand(),
          ],
        ),
        16.height,
        // Address field (optional)
        AppTextField(
          textFieldType: TextFieldType.MULTILINE,
          controller: addressCont,
          focus: addressFocus,
          isValidationRequired: false,
          maxLines: 2,
          minLines: 2,
          decoration: inputDecoration(context, labelText: "${language.hintAddress} (${language.notAvailable.toLowerCase()})"),
        ),
        16.height,
        _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: language.signUp,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            if (widget.isOTPLogin) {
              registerWithOTP();
            } else {
              registerUser();
            }
          },
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: '${language.lblAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: language.lblTermsOfService,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(appConfigurationStore.termConditions, launchMode: LaunchMode.externalApplication);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: language.privacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(appConfigurationStore.privacyPolicy, launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: "${language.alreadyHaveAccountTxt} ? ", style: secondaryTextStyle()),
            TextSpan(
              text: language.signIn,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        30.height,
      ],
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: transparentColor,
          leading: Container(
              margin: EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: BackWidget(iconColor: context.iconColor)),
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Form(
              key: formKey,
              autovalidateMode: isFirstTimeValidation ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    8.height,
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
