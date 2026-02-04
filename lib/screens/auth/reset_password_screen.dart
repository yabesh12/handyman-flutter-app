import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    passwordCont.dispose();
    confirmPasswordCont.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      if (passwordCont.text != confirmPasswordCont.text) {
        toast(language.passwordsDoNotMatch);
        return;
      }

      appStore.setLoading(true);

      Map<String, dynamic> request = {
        'email': widget.email,
        'password': passwordCont.text,
        'password_confirmation': confirmPasswordCont.text,
      };

      try {
        await resetPasswordWithOTP(request);
        appStore.setLoading(false);
        toast(language.passwordResetSuccessfully);

        // Navigate back to sign in screen
        finish(context, true);
      } catch (e) {
        appStore.setLoading(false);
        toast(e.toString());
      }
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    child: Icon(Icons.lock_reset, color: Colors.white, size: 40),
                  ),
                  24.height,
                  Text(
                    language.resetPassword,
                    style: boldTextStyle(size: 22),
                  ),
                  16.height,
                  Text(
                    language.enterNewPassword,
                    style: secondaryTextStyle(size: 14),
                    textAlign: TextAlign.center,
                  ),
                  32.height,
                  AppTextField(
                    textFieldType: TextFieldType.PASSWORD,
                    controller: passwordCont,
                    focus: passwordFocus,
                    nextFocus: confirmPasswordFocus,
                    errorThisFieldRequired: language.requiredText,
                    suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                    suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                    decoration: inputDecoration(context, labelText: language.newPassword),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.PASSWORD,
                    controller: confirmPasswordCont,
                    focus: confirmPasswordFocus,
                    errorThisFieldRequired: language.requiredText,
                    suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                    suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                    decoration: inputDecoration(context, labelText: language.confirmNewPassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return language.requiredText;
                      }
                      if (value != passwordCont.text) {
                        return language.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    onFieldSubmitted: (s) {
                      resetPassword();
                    },
                  ),
                  32.height,
                  AppButton(
                    text: language.resetPassword,
                    color: primaryColor,
                    textColor: Colors.white,
                    width: context.width() - 32,
                    onTap: () {
                      resetPassword();
                    },
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
