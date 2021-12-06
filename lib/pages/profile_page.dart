import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:szikapp/main.dart';

class ProfilePage extends StatelessWidget {
  static const String route = '/profile';
  static const String shortRoute = '/me';

  const ProfilePage({Key key = const Key('ProfilePage')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ide majd Scaffoldwithheader kell, de valamiért ebből a branchből nem látszott
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/default.png'),
                    fit: BoxFit.contain),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFILE_NAME'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: TextFormField(
                              initialValue: SZIKAppState.authManager.user!.name,
                              readOnly: true,
                            ),
                          ),
                        ),
                        Divider(
                            indent: 0,
                            endIndent: 10,
                            height: 1,
                            thickness: 4,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFILE_NICKNAME'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: TextFormField(
                              initialValue: SZIKAppState.authManager.user!.nick,
                              readOnly: false,
                            ),
                          ),
                        ),
                        Divider(
                            indent: 0,
                            endIndent: 10,
                            height: 1,
                            thickness: 4,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFILE_EMAIL'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: TextFormField(
                              initialValue:
                                  SZIKAppState.authManager.user!.email,
                              readOnly: true,
                            ),
                          ),
                        ),
                        Divider(
                            indent: 0,
                            endIndent: 10,
                            height: 1,
                            thickness: 4,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFILE_BIRTHDAY'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: TextFormField(
                              initialValue: SZIKAppState.authManager.user!
                                  .toString(), //itt a birthdaynek kell lenni, de nem tudtam a castolást hogy kell intézni:(
                              readOnly: true,
                            ),
                          ),
                        ),
                        Divider(
                            indent: 0,
                            endIndent: 10,
                            height: 1,
                            thickness: 4,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFILE_PHONENUMBER'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: TextFormField(
                              initialValue:
                                  SZIKAppState.authManager.user!.phone,
                              readOnly: false,
                            ),
                          ),
                        ),
                        Divider(
                            indent: 0,
                            endIndent: 10,
                            height: 1,
                            thickness: 4,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROFILE_GROUPS'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: TextFormField(
                              initialValue: SZIKAppState.authManager.user!
                                  .toString(), //itt pedig a GroupID-knak vagyis a neveiknek kellene állnia, ezzel sem boldogultam
                              readOnly: true,
                            ),
                          ),
                        ),
                        Divider(
                            indent: 0,
                            endIndent: 10,
                            height: 1,
                            thickness: 4,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
