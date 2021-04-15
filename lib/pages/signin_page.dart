import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../main.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key = const Key('SignInPage')}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    if (SZIKAppState.authManager.firebaseUser != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
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
                  onPressed: () => SZIKAppState.authManager.signIn(),
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
