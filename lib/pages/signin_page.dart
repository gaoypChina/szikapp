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
  bool selected = false;
  void _startAnimation() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  void initState() {
    setState(() {
      selected = false;
    });
    Future.delayed(Duration(milliseconds: 1), _startAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (SZIKAppState.authManager.isSignedIn) {
      @override
      void run() {
        scheduleMicrotask(() {
          Navigator.pushReplacementNamed(context, HomePage.route);
        });
      }

      run();
      return Container();
    } else {
      var queryData = MediaQuery.of(context);
      var devicePixelRatio = queryData.devicePixelRatio;
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/background_1.jpg'),
                    fit: BoxFit.cover)),
          ),
          AnimatedOpacity(
            duration: Duration(seconds: 2),
            opacity: selected ? 0.5 : 1,
            child: Container(
              color: Color(0xff59a3b0),
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutQuad,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: AnimatedAlign(
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOutQuad,
                        alignment: selected
                            ? FractionalOffset(0.5, 0.4)
                            : Alignment.center,
                        child: Image.asset(
                          'assets/pictures/logo_white_800.png',
                          width: 800 / devicePixelRatio,
                        ),
                      )),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: selected ? 1 : 0,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutQuad,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  SignInButton(
                    Buttons.Google,
                    onPressed: _onPressed,
                    text: 'SIGN_IN_MESSAGE'.tr(),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  void _onPressed() {
    SZIKAppState.authManager.signIn().then((success) => {
          if (success == true)
            Navigator.of(context).pushReplacementNamed(HomePage.route)
        });
  }
}
