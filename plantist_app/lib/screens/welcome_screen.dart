import 'package:flutter/material.dart';
import 'package:plantist_app/reusable_widgets/button/ui_button.dart';
import 'package:plantist_app/screens/sign_in_screen.dart';
import 'package:plantist_app/screens/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/WelcomeImageFinal.png',
          width: 310,
          height: 310,
        ),
        const SizedBox(height: 20),
        const TitleText(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: firebaseUIButton(
            context,
            "Sign in with email",
            Icons.mail,
            const Color(0xFFF5F5F5),
            Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
              );
            },
          ),
        ),
        signUpOption(context)
      ],
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Welcome back to',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          'Plantist',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Start your productive life now!',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
        )
      ],
    );
  }
}

Row signUpOption(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account?",
          style: TextStyle(color: Colors.grey)),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ),
          );
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
