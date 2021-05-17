import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

import '../business/janitor.dart';
import '../ui/screens/error_screen.dart';
import '../ui/screens/janitor_new_edit.dart';
import '../ui/widgets/tab_choice.dart';

class JanitorPage extends StatefulWidget {
  static const String route = '/janitor';
  JanitorPage({Key? key}) : super(key: key);

  @override
  _JanitorPageState createState() => _JanitorPageState();
}

class _JanitorPageState extends State<JanitorPage> {
  late final Janitor janitor;

  void _onTabChanged(int? newValue) {}

  void _onCreateTask() {
    Navigator.of(context).pushNamed(JanitorNewEditScreen.route,
        arguments: JanitorNewEditArguments(isEdit: false));
  }

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: janitor.refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return Scaffold();
          } else if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
          } else {
            var theme = Theme.of(context);
            return Container(
              padding:
                  EdgeInsets.fromLTRB(10, 30, 10, kBottomNavigationBarHeight),
              color: theme.colorScheme.background,
              child: Scaffold(
                body: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'JANITOR_TITLE'.tr().toUpperCase(),
                          style: theme.textTheme.headline2!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    TabChoice(labels: [
                      'JANITOR_TAB_ALL'.tr(),
                      'JANITOR_TAB_ACTIVE'.tr(),
                      'JANITOR_TAB_OWN'.tr(),
                    ], onChanged: _onTabChanged)
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: _onCreateTask,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(width: 36, height: 36),
                    child: Image.asset('assets/icons/plus_light_72.png'),
                  ),
                ),
              ),
            );
          }
        });
  }
}
