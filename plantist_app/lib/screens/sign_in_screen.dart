import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app/controllers/auth_controller.dart';
import 'package:plantist_app/reusable_widgets/button/color_changing_button.dart';
import 'package:plantist_app/reusable_widgets/text_field/password_text_field.dart';
import 'package:plantist_app/reusable_widgets/text_field/reusable_text_field.dart';
import 'package:plantist_app/reusable_widgets/text/reusable_subtitle_text.dart';
import 'package:plantist_app/reusable_widgets/text/reusable_title_text.dart';
import 'package:plantist_app/screens/reset_password.dart';
import 'package:plantist_app/utils/auth_manager.dart';
import 'package:plantist_app/utils/biometric_auth_manager.dart';

import '../controllers/email_validation_controller.dart';
import '../reusable_widgets/button/ui_button.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  final AuthManager _authManager = AuthManager();
  final EmailValidationController _emailValidationController =
      Get.put(EmailValidationController());
  final BiometricAuthManager _biometricAuthManager = BiometricAuthManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
            _emailTextController.clear();
            _passwordTextController.clear();
            authController.isButtonEnabled.value = false;
            _emailValidationController.resetState();
          },
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.topLeft,
                  child: ReusableTitleText("Sign in with email"),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: ReusableSubtitleText("Enter your email and password"),
                ),
                const SizedBox(height: 30),
                EmailField(
                  placeholder: "E-mail",
                  controller: _emailTextController,
                  scrollPadding: MediaQuery.of(context).viewInsets.bottom,
                  onChanged: (_) => _updateButtonState(),
                ),
                const SizedBox(height: 20),
                PasswordField(
                  placeholder: "Password",
                  controller: _passwordTextController,
                  scrollPadding: MediaQuery.of(context).viewInsets.bottom,
                  onChanged: (_) => _updateButtonState(),
                ),
                const SizedBox(height: 10),
                forgetPassword(context),
                Obx(() {
                  return colorChangingButton(
                    context: context,
                    title: "Sign In Using Email and Password",
                    icon: null,
                    backgroundColor: authController.isButtonEnabled.value
                        ? const Color.fromARGB(255, 15, 22, 39)
                        : const Color.fromARGB(255, 208, 20, 20),
                    textColor: Colors.white,
                    emailController: _emailTextController,
                    passwordController: _passwordTextController,
                    onPressed: () {
                      if (authController.isButtonEnabled.value) {
                        signIn();
                      }
                    },
                  );
                }),
                firebaseUIButton(
                  context,
                  "Sign In Using FaceID",
                  null,
                  const Color.fromARGB(255, 15, 22, 39),
                  Colors.white,
                  onTap: () {
                    _beginBiometricAuthentication();
                  },
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                          text: "By continuing you are accepting the "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openBottomSheet(privacyPolicyText);
                          },
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Terms of Use",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openBottomSheet(termsOfUseText);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResetPassword()),
          );
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  void _updateButtonState() {
    authController.updateButtonState(
      _emailTextController.text,
      _passwordTextController.text,
    );
  }

  Future<void> signIn() async {
    final email = _emailTextController.text.trim();
    final password = _passwordTextController.text.trim();

    try {
      final user = await _authManager.signIn(email, password);
      if (user != null) {
        print("Sign-in successful. User: ${user.email}");
        await _biometricAuthManager.storeCredentials(email, password);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (_) => false,
        );
      } else {
        print("Sign-in failed.");
      }
    } catch (error) {
      print("Sign-in error: ${error.toString()}");
    }
  }

  void _beginBiometricAuthentication() async {
    bool authenticated =
        await _biometricAuthManager.authenticateWithBiometrics();
    if (authenticated) {
      _signInWithBiometrics();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Biometric authentication failed'),
          content: const Text('Please use email and password to sign in.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _signInWithBiometrics() async {
    try {
      final credentials = await _biometricAuthManager.retrieveCredentials();
      final email = credentials['email'] ?? '';
      final password = credentials['password'] ?? '';

      if (email.isNotEmpty && password.isNotEmpty) {
        final user = await _authManager.signIn(email, password);
        if (user != null) {
          print("Sign-in successful with biometrics. User: ${user.email}");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (_) => false,
          );
        } else {
          print("Sign-in failed with biometrics.");
        }
      } else {
        print('No stored credentials found. Prompting user for credentials.');

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No stored credentials found'),
            content: const Text('Please use email and password to sign in.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print("Error signing in with biometrics: ${error.toString()}");
    }
  }

  void _openBottomSheet(String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  final String privacyPolicyText = """
    Privacy Policy

    This Privacy Policy describes how your personal information is collected, used, and shared when you use our mobile application.
    Information we collect:
    - We collect information you provide when you sign up for an account.
    - We also collect information automatically when you use the app, such as your usage data.

    How we use your information:
    - We use the information to provide and improve our services.
    - Your data may be used for analytics purposes.

    Information sharing:
    - We may share your information with third-party service providers for specific purposes.
  """;

  final String termsOfUseText = """
    Terms of Use

    By using this app, you agree to these terms of use. If you do not agree to these terms, please do not use the app.
    Your responsibilities:
    - You are responsible for maintaining the confidentiality of your account.
    - You must not misuse the app or violate any laws.

    Limitation of liability:
    - We are not liable for any damages arising out of the use or inability to use the app.
""";
}
