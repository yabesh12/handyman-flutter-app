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

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  OtpVerificationScreen({required this.email, this.isPasswordReset = false});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _otpVerified = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _sendOtp();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    appStore.setLoading(true);
    try {
      final endpoint = widget.isPasswordReset ? 'send-reset-otp' : 'send-registration-otp';
      await sendOtp(email: widget.email, endpoint: endpoint);
      toast('OTP sent to ${widget.email}');
    } catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    _startResendTimer();
    await _sendOtp();
  }

  Future<void> _verifyOtp() async {
    if (otpController.text.length != 6) {
      toast('Please enter 6-digit OTP');
      return;
    }

    appStore.setLoading(true);
    try {
      if (widget.isPasswordReset) {
        setState(() => _otpVerified = true);
        appStore.setLoading(false);
      } else {
        final endpoint = 'verify-registration-otp';
        await verifyOtp(email: widget.email, otp: otpController.text, endpoint: endpoint);
        toast('Email verified successfully!');
        finish(context, true);
      }
    } catch (e) {
      toast(e.toString());
      appStore.setLoading(false);
    }
  }

  Future<void> _resetPassword() async {
    if (newPasswordController.text.length < 6) {
      toast('Password must be at least 6 characters');
      return;
    }

    appStore.setLoading(true);
    try {
      await resetPasswordWithOtp(
        email: widget.email,
        otp: otpController.text,
        newPassword: newPasswordController.text,
      );
      toast('Password changed successfully!');
      finish(context, true);
    } catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparentColor,
        leading: Container(
          margin: EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: BackWidget(iconColor: context.iconColor),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
          statusBarColor: context.scaffoldBackgroundColor,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                (context.height() * 0.08).toInt().height,
                Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
                  child: Icon(Icons.email_outlined, color: Colors.white, size: 40),
                ),
                24.height,
                Text(
                  widget.isPasswordReset ? 'Reset Password' : 'Verify Email',
                  style: boldTextStyle(size: 22),
                ),
                16.height,
                Text(
                  'Enter the 6-digit code sent to\n${widget.email}',
                  style: secondaryTextStyle(size: 14),
                  textAlign: TextAlign.center,
                ),
                32.height,
                if (!_otpVerified) ...[
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    textStyle: boldTextStyle(size: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
                    cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
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
                    onChanged: (value) {},
                    beforeTextPaste: (text) => true,
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive the code? ", style: secondaryTextStyle()),
                      TextButton(
                        onPressed: _canResend ? _resendOtp : null,
                        child: Text(
                          _canResend ? 'Resend OTP' : 'Resend in ${_resendTimer}s',
                          style: boldTextStyle(
                            color: _canResend ? primaryColor : Colors.grey,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.height,
                  AppButton(
                    text: widget.isPasswordReset ? 'Verify OTP' : 'Verify Email',
                    color: primaryColor,
                    textColor: Colors.white,
                    width: context.width() - 64,
                    onTap: _verifyOtp,
                  ),
                ] else ...[
                  // Password reset form after OTP verified
                  Text(
                    'OTP Verified! Enter new password',
                    style: boldTextStyle(size: 16, color: Colors.green),
                  ),
                  24.height,
                  AppTextField(
                    textFieldType: TextFieldType.PASSWORD,
                    controller: newPasswordController,
                    decoration: inputDecoration(context, labelText: 'New Password'),
                  ),
                  24.height,
                  AppButton(
                    text: 'Reset Password',
                    color: primaryColor,
                    textColor: Colors.white,
                    width: context.width() - 64,
                    onTap: _resetPassword,
                  ),
                ],
              ],
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
