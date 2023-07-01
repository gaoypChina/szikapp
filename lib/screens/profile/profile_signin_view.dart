import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../navigation/navigation.dart';
import '../../utils/utils.dart';

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({super.key});

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
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

  void _onPressed(SignInMethod method) {
    if (SzikAppState.connectionStatus == ConnectivityResult.none) {
      Provider.of<SzikAppStateManager>(context, listen: false)
          .setError(error: NoConnectionException('ERROR_NO_INTERNET'.tr()));
    } else {
      var gdprAcceptanceDate =
          Settings.instance.gdprAcceptanceDate ?? DateTime(1800);
      if (Settings.instance.gdprAccepted &&
          gdprAcceptanceDate
              .isBefore(DateTime.now().subtract(const Duration(days: 730)))) {
        showDialog(
          context: context,
          builder: (context) {
            return GDPRWidget(
              onAgreePressed: () {
                Provider.of<AuthManager>(context, listen: false)
                    .signIn(method: method);
                SzikAppState.analytics.logEvent(name: 'sign_in');
                Settings.instance.gdprAccepted = true;
                Settings.instance.gdprAcceptanceDate = DateTime.now();
                Settings.instance.savePreferences();
                Navigator.pop(context);
              },
              onDisagreePressed: () {
                SzikAppState.analytics.logEvent(name: 'sign_in_abort_gdpr');
                Navigator.pop(context);
              },
            );
          },
        );
      } else {
        Provider.of<AuthManager>(context, listen: false).signIn(method: method);
        SzikAppState.analytics.logEvent(name: 'sign_in');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    return CustomScaffold(
      withNavigationBar: false,
      resizeToAvoidBottomInset: true,
      appBarTitle: 'SIGN_IN_TITLE'.tr(),
      body: Stack(
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
                      onPressed: () => _onPressed(SignInMethod.google),
                      text: 'SIGN_IN_BUTTON_GOOGLE'.tr(),
                    ),
                    SignInButton(
                      Buttons.Apple,
                      onPressed: () => _onPressed(SignInMethod.apple),
                      text: 'SIGN_IN_BUTTON_APPLE'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
