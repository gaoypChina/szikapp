import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/navigation.dart';
import 'app_bar.dart';
import 'bottom_navigation_bar.dart';

class CustomScaffold extends StatelessWidget {
  final String? appBarTitle;
  final Widget? body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool withAppBar;
  final bool withBackButton;
  final bool withNavigationBar;

  ///Shiny Scaffold with optional [BottomNavigationBar] and [AppBar].
  const CustomScaffold({
    super.key,
    this.appBarTitle,
    this.body,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.withAppBar = true,
    this.withBackButton = true,
    this.withNavigationBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: withAppBar
          ? buildCustomAppBar(
              context: context,
              appBarTitle: appBarTitle ?? '',
              withBackButton: withBackButton,
            )
          : null,
      body: SafeArea(child: body ?? Container()),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: withNavigationBar
          ? CustomBottomNavigationBar(
              selectedTab:
                  Provider.of<SzikAppStateManager>(context, listen: false)
                      .selectedTab,
            )
          : null,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
