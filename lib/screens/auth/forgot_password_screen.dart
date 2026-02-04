import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/auth/email_otp_verification_screen.dart';
import 'package:booking_system_flutter/screens/auth/reset_password_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  // AC Chill - 3-Step Forgot Password Flow
  Future<void> forgotPwd() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map req = {
        UserKeys.email: emailCont.text.validate(),
      };

      forgotPassword(req).then((res) async {
        appStore.setLoading(false);
        toast(res.message.validate());

        // Step 2: Navigate to OTP verification
        bool? otpVerified = await EmailOTPVerificationScreen(
          email: emailCont.text.trim(),
          isFromForgotPassword: true,
        ).launch(context);

        if (otpVerified == true) {
          // Step 3: Navigate to reset password screen
          bool? passwordReset = await ResetPasswordScreen(
            email: emailCont.text.trim(),
          ).launch(context);

          if (passwordReset == true) {
            // Close the forgot password dialog
            finish(context);
          }
        }
      }).catchError((e) {
        toast(e.toString(), print: true);
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: boxDecorationDefault(
                color: context.primaryColor,
                borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.forgotPassword, style: boldTextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(Icons.clear, color: Colors.white, size: 20),
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${language.hintEmailAddressTxt}", style: boldTextStyle()),
                6.height,
                Text(language.lblForgotPwdSubtitle, style: secondaryTextStyle()),
                24.height,
                Observer(
                  builder: (_) => AppTextField(
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    controller: emailCont,
                    autoFocus: true,
                    errorThisFieldRequired: language.requiredText,
                    decoration: inputDecoration(context, labelText: language.hintEmailTxt),
                  ).visible(!appStore.isLoading, defaultWidget: Loader()),
                ),
                16.height,
                AppButton(
                  text: language.btnSendOtp,
                  color: primaryColor,
                  textColor: Colors.white,
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    forgotPwd();
                  },
                ),
              ],
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
