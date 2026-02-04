import 'dart:async';
import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailOTPVerificationScreen extends StatefulWidget {
  final String email;
  final bool isFromForgotPassword;

  EmailOTPVerificationScreen({
    required this.email,
    this.isFromForgotPassword = false,
  });

  @override
  _EmailOTPVerificationScreenState createState() => _EmailOTPVerificationScreenState();
}

class _EmailOTPVerificationScreenState extends State<EmailOTPVerificationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _remainingSeconds = 60;
    _canResend = false;
    setState(() {});

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        setState(() {});
      } else {
        _canResend = true;
        _timer?.cancel();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOTP() async {
    hideKeyboard(context);

    if (otpController.text.length != 6) {
      toast(language.pleaseEnterValidOTP);
      return;
    }

    appStore.setLoading(true);

    Map<String, dynamic> request = {
      'email': widget.email,
      'otp': otpController.text,
    };

    try {
      if (widget.isFromForgotPassword) {
        await verifyResetOTP(request);
        appStore.setLoading(false);
        toast(language.otpVerifiedSuccessfully);
        finish(context, true);
      } else {
        await verifyEmailOTP(request);
        appStore.setLoading(false);
        toast(language.emailVerifiedSuccessfully);
        finish(context, true);
      }
    } catch (e) {
      appStore.setLoading(false);
      toast(e.toString());
    }
  }

  Future<void> resendOTP() async {
    if (!_canResend) return;

    appStore.setLoading(true);

    Map<String, dynamic> request = {
      'email': widget.email,
    };

    try {
      if (widget.isFromForgotPassword) {
        await forgotPassword(request);
      } else {
        await resendEmailOTP(request);
      }
      appStore.setLoading(false);
      toast(language.otpSentSuccessfully);
      startTimer();
    } catch (e) {
      appStore.setLoading(false);
      toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackWidget(iconColor: context.iconColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
          statusBarColor: context.scaffoldBackgroundColor,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  32.height,
                  Container(
                    height: 80,
                    width: 80,
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationDefault(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: Icon(Icons.email_outlined, color: Colors.white, size: 40),
                  ),
                  24.height,
                  Text(
                    widget.isFromForgotPassword
                        ? language.verifyResetOTP
                        : language.verifyEmail,
                    style: boldTextStyle(size: 22),
                  ),
                  16.height,
                  Text(
                    '${language.enterOTPSentTo}\n${widget.email}',
                    style: secondaryTextStyle(size: 14),
                    textAlign: TextAlign.center,
                  ),
                  32.height,
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: context.cardColor,
                      inactiveFillColor: context.cardColor,
                      selectedFillColor: context.cardColor,
                      activeColor: primaryColor,
                      inactiveColor: borderColor,
                      selectedColor: primaryColor,
                    ),
                    enableActiveFill: true,
                    onCompleted: (value) {
                      verifyOTP();
                    },
                    onChanged: (value) {},
                  ),
                  24.height,
                  AppButton(
                    text: language.verify,
                    color: primaryColor,
                    textColor: Colors.white,
                    width: context.width() - 32,
                    onTap: () {
                      verifyOTP();
                    },
                  ),
                  24.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(language.didNotReceiveOTP, style: secondaryTextStyle()),
                      8.width,
                      TextButton(
                        onPressed: _canResend ? resendOTP : null,
                        child: Text(
                          _canResend
                              ? language.resendOTP
                              : '${language.resendIn} $_remainingSeconds s',
                          style: boldTextStyle(
                            color: _canResend ? primaryColor : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
