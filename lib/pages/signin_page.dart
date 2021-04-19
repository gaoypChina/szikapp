import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../main.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'submenu_page.dart';

class SignInPage extends StatefulWidget {
  static const String route = '/signin';

  const SignInPage({Key key = const Key('SignInPage')}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool selected = false;
  bool logoSelected = false;
  void _startAnimation() {
    setState(() {
      logoSelected = true;
    });
    Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
          selected = true;
        }));
  }

  @override
  void initState() {
    setState(() {
      selected = false;
    });
    Future.delayed(Duration(microseconds: 10), _startAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (SZIKAppState.authManager.isSignedIn) {
      @override
      void run() {
        scheduleMicrotask(() {
          Navigator.pushReplacementNamed(context, MenuPage.route);
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
            // Háttérkép
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/background_1.jpg'),
                    fit: BoxFit.cover)),
          ),
          AnimatedOpacity(
            // Háttérszín (animált)
            duration: Duration(seconds: 2),
            opacity: selected ? 0.5 : 1,
            child: Container(
              color: Color(0xff59a3b0),
            ),
          ),
          AnimatedContainer(
            // Sign_In_Button (animated)
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
                        alignment: logoSelected
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
          DelayedDisplay(
            delay: Duration(milliseconds: 1500),
            slidingBeginOffset: Offset(0.0, 0.02),
            child: AnimatedOpacity(
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
            ),
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 1500),
            slidingBeginOffset: Offset(0.0, 0.02),
            child: AnimatedOpacity(
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
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SubMenuPage.route);
                      },
                      text: 'Almenü oldal',
                    ),
                  ],
                ),
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
