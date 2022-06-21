import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../navigation/app_state_manager.dart';
import '../utils/utils.dart';
import 'progress_screen.dart';

class SignInScreenView extends StatelessWidget {
  const SignInScreenView({Key key = const Key('SignInScreen')})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      withNavigationBar: false,
      resizeToAvoidBottomInset: true,
      appBarTitle: 'SIGN_IN_TITLE'.tr(),
      body: CustomFutureBuilder(
        future:
            Provider.of<AuthManager>(context, listen: false).signInSilently(),
        shimmer: const ProgressScreen(),
        child: const SignInWidget(),
      ),
    );
  }
}

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool _started = false;

  void _startAnimation() {
    if (mounted) {
      setState(() {
        _started = true;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 100), _startAnimation);
    super.initState();
  }

  void _onPressed() {
    if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
      Provider.of<SzikAppStateManager>(context, listen: false)
          .setError(NoConnectionException('ERROR_NO_INTERNET'.tr()));
    } else {
      var method = Platform.isIOS ? SignInMethod.apple : SignInMethod.google;
      if (Settings.instance.firstRun) {
        showDialog(
          context: context,
          builder: (context) {
            return GDPRWidget(
              onAgreePressed: () {
                Provider.of<AuthManager>(context, listen: false)
                    .signIn(method: method);
                Navigator.pop(context);
              },
              onDisagreePressed: () => Navigator.pop(context),
            );
          },
        );
      } else {
        Provider.of<AuthManager>(context, listen: false).signIn(method: method);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pictures/background_1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _started ? 0.5 : 1,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutQuad,
          child: Center(
            child: AnimatedOpacity(
              opacity: _started ? 1 : 0,
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pictures/logo_white_800.png',
                    width: min(
                      800 / queryData.devicePixelRatio,
                      queryData.size.height / 3,
                    ),
                  ),
                  SignInButton(
                    Buttons.Google,
                    onPressed: _onPressed,
                    text: 'SIGN_IN_BUTTON_GOOGLE'.tr(),
                  ),
                  if (Platform.isIOS)
                    SignInButton(
                      Buttons.Apple,
                      onPressed: _onPressed,
                      text: 'SIGN_IN_BUTTON_APPLE'.tr(),
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
