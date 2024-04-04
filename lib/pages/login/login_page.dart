import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:titan_app/pages/login/password_page.dart';
import 'package:titan_app/pages/login/register_page.dart';
import 'package:titan_app/utils/system_utils.dart';

import '../../generated/l10n.dart';
import '../../providers/auth_provider.dart';
import '../../themes/colors.dart';
import '../../widgets/common_input_field.dart';
import '../../widgets/common_text_widget.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/privacy_agreement_widget.dart';
import '../../widgets/underline_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.backgroundColor,
      // Extend the body behind the AppBar, including the status bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          _topBackground(context),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _welcomeItem(context),
                const LoginForm(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _topBackground(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Positioned(
      top: -statusBarHeight,
      left: 0,
      right: 0,
      child: Container(
        height: 218,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_top_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _welcomeItem(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.fromLTRB(36.w, 59.h + statusBarHeight, 36.w, 48.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.asset("assets/images/login_icon.png"),
        SizedBox(
          height: 14.h,
        ),
        CommonTextWidget(
          S.of(context).welcome_to_titan,
          fontSize: FontSize.biggest,
        ),
      ]),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _agreedToTerms = false;
  bool _isButtonEnabled = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void toRegisterPage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RegisterPage(),
        transitionDuration: const Duration(seconds: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  void toHomePage() {
    LoadingIndicator.show(context, message: '登录中');
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(seconds: 3), () {
      Provider.of<AuthProvider>(context, listen: false)
          .login(_emailController.text, _passwordController.text);
      LoadingIndicator.hide(context);
    });
  }

  void toPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordPage()),
    );
  }

  void updateButtonState(String text) {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  void login() {
    if (!_isButtonEnabled) {
      return;
    }
    toHomePage();
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
            CommonInputField(
              controller: _passwordController,
              hintText: S.of(context).password,
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: updateButtonState,
            ),
            SizedBox(height: 10.0.h),
            Align(
              alignment: Alignment.centerRight,
              child: UnderlinedText(
                text: S.of(context).forget_password,
                onTap: toPasswordPage,
              ),
            ),
            SizedBox(height: 20.0.h),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled
                    ? AppDarkColors.themeColor
                    : AppDarkColors.disableThemeColor,
                minimumSize: Size(300.w, 56.h),
              ),
              child: Text(
                S.of(context).login,
                style: TextStyle(
                    color: AppDarkColors.backgroundColor, fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 87.0.h),
            Align(
              alignment: Alignment.center,
              child: UnderlinedText(
                text: S.of(context).register_entry,
                onTap: toRegisterPage,
              ),
            ),
            SizedBox(height: SystemUtils.isIOS ? 148.h : 198.h),
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return PrivacyAgreementWidget(auth.isPrivacySigned,
                    onChanged: (value) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .changePrivacy();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
