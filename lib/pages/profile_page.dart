import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../ui/widgets/profile_fields.dart';

class ProfilePage extends StatelessWidget {
  static const String route = '/profile';
  static const String shortRoute = '/me';

  const ProfilePage({Key key = const Key('ProfilePage')}) : super(key: key);

  String buildGroupNamesFromIDs(List<String> ids) {
    var result = '';
    for (var item in ids) {
      result +=
          SZIKAppState.groups.firstWhere((element) => element.id == item).name;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40,
                foregroundImage: NetworkImage(
                  SZIKAppState.authManager.user!.profilePicture.toString(),
                ),
              ),
            ),
            Form(
              child: Column(
                children: [
                  ProfileTextField(
                    label: 'PROFILE_NAME'.tr(),
                    initialValue: SZIKAppState.authManager.user!.name,
                    readOnly: true,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_NICKNAME'.tr(),
                    initialValue: SZIKAppState.authManager.user!.nick,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_EMAIL'.tr(),
                    initialValue: SZIKAppState.authManager.user!.email,
                    readOnly: true,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_BIRTHDAY'.tr(),
                    initialValue: SZIKAppState.authManager.user!.birthday !=
                            null
                        ? DateFormat('yyyy. MM. dd.')
                            .format(SZIKAppState.authManager.user!.birthday!)
                        : null,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_PHONENUMBER'.tr(),
                    initialValue: SZIKAppState.authManager.user!.phone,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_GROUPS'.tr(),
                    initialValue: buildGroupNamesFromIDs(
                        SZIKAppState.authManager.user!.groupIDs ?? []),
                    readOnly: true,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
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
