import 'package:flutter/material.dart';
import 'package:smartinventory/screens/LoginScreen.dart';
import 'package:smartinventory/screens/SignUpScreen.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';
import 'package:smartinventory/widgets/WelcomeButton.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome Back!\n',
                            style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        TextSpan(
                            text:
                                '\nEnter personal details to your employee account',
                            style: TextStyle(fontSize: 20, color: Colors.white)
                            // height: 0,
                            )
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Log in',
                      onTap: LoginScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  // Expanded(
                  //   child: WelcomeButton(
                  //     buttonText: 'Sign up',
                  //     onTap: const SignUpScreen(),
                  //     color: Colors.white,
                  //     textColor: lightColorScheme.primary,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
