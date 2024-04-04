import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/auth_provider.dart';
import '../../themes/colors.dart';
import '../../utils/system_utils.dart';
import '../../widgets/common_input_field.dart';
import '../../widgets/common_text_widget.dart';
import '../../widgets/privacy_agreement_widget.dart';
import '../../widgets/underline_text.dart';
import '../../widgets/verification_code_input_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppDarkColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(36.w, 132.h, 36.w, 28.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        S.of(context).register,
                        fontSize: FontSize.biggest,
                      ),
                    ]),
              ),
              const RegisterForm(),
            ],
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _invitationCodeController =
      TextEditingController();

  String _email = '';
  String _emailCode = '';
  String _password = '';
  String _confirmPassword = '';
  String _invitationCode = '';
  bool _isButtonEnabled = false;

  bool _agreedToTerms = false;

  void loginAction() {
    Navigator.of(context).pop();
  }

  void registerAction() {
    if (!_isButtonEnabled) {
      return;
    }
  }

  void updateButtonState(String text) {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _emailCodeController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _invitationCodeController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                  return 'Please enter your email';
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
            SizedBox(height: 10.0.h),
            CommonInputField(
              controller: _invitationCodeController,
              hintText: S.of(context).invitation_code,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: updateButtonState,
            ),
            SizedBox(height: 39.0.h),
            ElevatedButton(
              onPressed: registerAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled
                    ? AppDarkColors.themeColor
                    : AppDarkColors.disableThemeColor,
                minimumSize: Size(300.w, 56.h),
              ),
              child: Text(
                S.of(context).register,
                style: TextStyle(
                    color: AppDarkColors.backgroundColor, fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 15.0.h),
            Align(
              alignment: Alignment.center,
              child: UnderlinedText(
                text: S.of(context).login_entry,
                onTap: loginAction,
              ),
            ),
            SizedBox(height: SystemUtils.isIOS ? 108.h : 130.h),
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
