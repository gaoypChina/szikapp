import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../main.dart';
import 'error_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String route = '/signin';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: SignInScreen(),
    );
  }

  const SignInScreen({Key key = const Key('SignInScreen')}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _started = false;
  bool _logoStarted = false;

  void _startAnimation() {
    setState(() {
      _logoStarted = true;
    });
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          _started = true;
        }));
  }

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 10), _startAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (SZIKAppState.authManager.isSignedIn) {
      @override
      void run() {
        scheduleMicrotask(() {
          SZIKAppState.analytics.logEvent(name: 'SIGN_IN_ALREADY_SIGNED_IN');
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
            // Háttérkép
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/background_1.jpg'),
                    fit: BoxFit.cover)),
          ),
          AnimatedOpacity(
            // Háttérszín (animált)
            duration: const Duration(seconds: 2),
            opacity: _started ? 0.5 : 1,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          AnimatedContainer(
            // Sign_In_Button (animated)
            duration: const Duration(seconds: 2),
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
                        alignment: _logoStarted
                            ? const FractionalOffset(0.5, 0.4)
                            : Alignment.center,
                        child: Image.asset(
                          'assets/pictures/logo_white_800.png',
                          width: min(800 / devicePixelRatio,
                              queryData.size.height / 3),
                        ),
                      )),
                ],
              ),
            ),
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 1500),
            slidingBeginOffset: const Offset(0.0, 0.02),
            child: AnimatedOpacity(
              opacity: _started ? 1 : 0,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOutQuad,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: _onPressed,
                      text: 'SIGN_IN_BUTTON'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  void _onPressed() {
    if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
      Navigator.of(context).pushNamed(ErrorScreen.route,
          arguments: ErrorScreenArguments(error: 'ERROR_NO_INTERNET'.tr()));
    } else {
      SZIKAppState.authManager.signIn().then(
        (success) {
          if (success == true) {
            SZIKAppState.analytics.logLogin(loginMethod: 'sign_in_google');
            Navigator.of(context).pushReplacementNamed(HomePage.route);
          }
        },
      ).catchError(
        (error) {
          Navigator.of(context).pushNamed(ErrorScreen.route,
              arguments: ErrorScreenArguments(error: error));
        },
      );
    }
  }
}
