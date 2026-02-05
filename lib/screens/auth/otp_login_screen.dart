// UX Serve - Firebase Phone OTP removed
// This screen is kept as a stub to avoid breaking imports

import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({Key? key}) : super(key: key);

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Login', style: boldTextStyle(size: 20)),
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Navigator.of(context).canPop() ? BackWidget(iconColor: context.iconColor) : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sms_outlined, size: 64, color: Colors.grey),
            16.height,
            Text('OTP Login coming soon', style: boldTextStyle(size: 18)),
            8.height,
            Text('Please use email and password to sign in', style: secondaryTextStyle()),
          ],
        ),
      ),
    );
  }
}
