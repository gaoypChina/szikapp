import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_bar.dart';
import '../components/bottom_navigation_bar.dart';
import '../components/profile_fields.dart';
import '../navigation/app_state_manager.dart';
import '../utils/auth_manager.dart';
import '../utils/exceptions.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';
  static const String shortRoute = '/me';

  final AuthManager manager;

  static MaterialPage page({required AuthManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ProfileScreen(
        manager: manager,
      ),
    );
  }

  const ProfileScreen({
    Key key = const Key('ProfileScreen'),
    required this.manager,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool changed = false;
  bool error = false;
  String? nick;
  DateTime? birthday;
  String? phone;

  String buildGroupNamesFromIDs(List<String> ids) {
    var result = '';
    var groups =
        Provider.of<SzikAppStateManager>(context, listen: false).groups;
    for (var item in ids) {
      result += groups.firstWhere((element) => element.id == item).name;
    }
    return result;
  }

  void _onNickChanged(String newValue) {
    setState(() {
      nick = newValue;
      changed = true;
    });
  }

  void _onPhoneChanged(String newValue) {
    setState(() {
      phone = newValue;
      changed = true;
    });
  }

  void _onBirthdayChanged(String newValue) {
    var parsed = newValue.split('.');
    if (parsed.length == 4) {
      var date = DateTime(
        int.parse(parsed.first.trim()),
        int.parse(parsed[1].trim()),
        int.parse(parsed[2].trim()),
      );
      setState(() {
        birthday = date;
        changed = true;
      });
    }
  }

  void _onSend() {
    try {
      if (_formKey.currentState!.validate()) {
        widget.manager.user!.nick = nick;
        widget.manager.user!.phone = phone;
        widget.manager.user!.birthday = birthday;
        widget.manager.pushUserUpdate();
        setState(() {
          changed = false;
        });
        widget.manager.pullUserUpdate();
      }
    } on NotValidPhoneException {
      setState(() {
        error = true;
      });
    } on NotValidBirthdayException {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nick = widget.manager.user!.nick;
    birthday = widget.manager.user!.birthday;
    phone = widget.manager.user!.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(context: context, appBarTitle: 'PROFILE_TITLE'.tr()),
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
                  widget.manager.user!.profilePicture.toString(),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileTextField(
                    label: 'PROFILE_NAME'.tr(),
                    initialValue: widget.manager.user!.name,
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
                    initialValue: widget.manager.user!.email,
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
                        widget.manager.user!.groupIDs ?? []),
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
      bottomNavigationBar: SzikBottomNavigationBar(
        selectedTab: Provider.of<SzikAppStateManager>(context, listen: false)
            .selectedTab,
      ),
    );
  }
}
