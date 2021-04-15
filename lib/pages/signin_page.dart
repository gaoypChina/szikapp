import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../main.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static const String route = '/signin';

  const SignInPage({Key key = const Key('SignInPage')}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  void _onPressed() {
    SZIKAppState.authManager.signIn().then((value) => {
          if (value == true)
            Navigator.of(context).pushReplacementNamed(HomePage.route)
        });
  }

  @override
  Widget build(BuildContext context) {
    if (SZIKAppState.authManager.firebaseUser != null) {
      @override
      void run() {
        scheduleMicrotask(() {
          Navigator.pushReplacementNamed(context, HomePage.route);
        });
      }

      run();
      return Container();
    } else {
      return Scaffold(
        backgroundColor: Color(0xff59a3b0),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Color(0xff59a3b0).withOpacity(0.5), BlendMode.dstATop),
                  image: AssetImage('assets/pictures/background_1.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/pictures/logo_white_500.png',
                  width: 250,
                ),
                SizedBox(
                  height: 30,
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: _onPressed,
                  text: 'SIGN_IN_MESSAGE'.tr(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
