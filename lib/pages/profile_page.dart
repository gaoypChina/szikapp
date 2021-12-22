import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../ui/widgets/profile_fields.dart';
import '../utils/exceptions.dart';

class ProfilePage extends StatefulWidget {
  static const String route = '/profile';
  static const String shortRoute = '/me';

  const ProfilePage({Key key = const Key('ProfilePage')}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool changed = false;
  String? nick;
  DateTime? birthday;
  String? phone;

  String buildGroupNamesFromIDs(List<String> ids) {
    var result = '';
    for (var item in ids) {
      result +=
          SZIKAppState.groups.firstWhere((element) => element.id == item).name;
    }
    return result;
  }

  void _onNickChanged(String newValue) {
    SZIKAppState.authManager.user!.nick = newValue;
    setState(() {
      nick = newValue;
      changed = true;
    });
  }

  void _onPhoneChanged(String newValue) {
    try {
      SZIKAppState.authManager.user!.phone = newValue;
      setState(() {
        phone = newValue;
        changed = true;
      });
    } on NonHungarianPhoneException {
      setState(() {
        phone = newValue;
        changed = true;
      });
    }
  }

  void _onBirthdayChanged(String newValue) {
    try {
      var parsed = newValue.split('. ');
      if (parsed.length == 3) {
        var date = DateTime(
          int.parse(parsed.first),
          int.parse(parsed[1]),
          int.parse(parsed.last),
        );
        SZIKAppState.authManager.user!.birthday = date;
        setState(() {
          birthday = date;
          changed = true;
        });
      }
    } on NotValidBirthdayException {
      return;
    }
  }

  void _onSend() {
    if (_formKey.currentState!.validate()) {
      SZIKAppState.authManager.updateUser();
      setState(() {
        changed = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nick = SZIKAppState.authManager.user!.nick;
    birthday = SZIKAppState.authManager.user!.birthday;
    phone = SZIKAppState.authManager.user!.phone;
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
              key: _formKey,
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
                    initialValue: nick,
                    onChanged: _onNickChanged,
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
                    initialValue: birthday != null
                        ? DateFormat('yyyy. MM. dd.').format(birthday!)
                        : null,
                    onChanged: _onBirthdayChanged,
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_PHONENUMBER'.tr(),
                    initialValue: phone,
                    onChanged: _onPhoneChanged,
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
            changed
                ? Center(
                    child: ElevatedButton(
                      child: Text('BUTTON_SEND'.tr()),
                      onPressed: _onSend,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
