import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/themes/colors.dart';

import '../../generated/l10n.dart';
import '../../providers/auth_provider.dart';
import '../../utils/system_utils.dart';
import '../../widgets/common_input_field.dart';
import '../../widgets/common_text_widget.dart';
import '../../widgets/privacy_agreement_widget.dart';
import '../../widgets/verification_code_input_field.dart';
import 'login_page.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppDarkColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppDarkColors.backgroundColor,
          iconTheme: const IconThemeData(color: AppDarkColors.iconColor),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(36.w, 30.h, 36.w, 28.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        S.of(context).forget_password,
                        fontSize: FontSize.biggest,
                      ),
                    ]),
              ),
              const PasswordPageForm(),
            ],
          ),
        ));
  }
}

class PasswordPageForm extends StatefulWidget {
  const PasswordPageForm({super.key});

  @override
  _PasswordPageFormState createState() => _PasswordPageFormState();
}

class _PasswordPageFormState extends State<PasswordPageForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _email = '';
  String _emailCode = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isButtonEnabled = false;

  bool _agreedToTerms = false;

  void loginAction() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionDuration: const Duration(seconds: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  void updateButtonState(String text) {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _emailCodeController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  void changePassword() {
    if (!_isButtonEnabled) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {});
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CommonInputField(
              controller: _emailController,
              hintText: S.of(context).email,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email ';
                }
                return null;
              },
              onChanged: updateButtonState,
            ),
            SizedBox(height: 10.h),
            VerificationCodeInputField(
              controller: _emailCodeController,
              hintText: S.of(context).email_verification_code,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: updateButtonState,
            ),
            SizedBox(height: 10.0.h),
            CommonInputField(
              controller: _passwordController,
              hintText: S.of(context).set_password,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: updateButtonState,
            ),
            SizedBox(height: 10.0.h),
            CommonInputField(
              controller: _confirmPasswordController,
              hintText: S.of(context).confirm_password,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: updateButtonState,
            ),
            SizedBox(height: 104.0.h),
            ElevatedButton(
              onPressed: changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled
                    ? AppDarkColors.themeColor
                    : AppDarkColors.disableThemeColor,
                minimumSize: Size(300.w, 56.h),
              ),
              child: Text(
                S.of(context).confirm_modification,
                style: TextStyle(
                    color: AppDarkColors.backgroundColor, fontSize: 18.sp),
              ),
            ),
            SizedBox(height: SystemUtils.isIOS ? 140.h : 188.h),
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return PrivacyAgreementWidget(auth.isPrivacySigned,
                    onChanged: (value) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .changePrivacy();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
