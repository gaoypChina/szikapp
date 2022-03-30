import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/auth_manager.dart';
import '../components/components.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';
import '../utils/exceptions.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/me';

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
      newValue.isEmpty ? nick = null : nick = newValue;
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

  void _onCancel() {
    setState(() {
      nick = widget.manager.user!.nick;
      birthday = widget.manager.user!.birthday;
      phone = widget.manager.user!.phone;
      changed = false;
    });
  }

  List<Widget> _buildActionButtons(bool changed) {
    return changed
        ? [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.close,
                size: kIconSizeNormal,
              ),
              label: Text('BUTTON_DISMISS'.tr()),
              onPressed: _onCancel,
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.done,
                size: kIconSizeNormal,
              ),
              label: Text('BUTTON_SAVE'.tr()),
              onPressed: _onSend,
            )
          ]
        : [];
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
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'PROFILE_TITLE'.tr(),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: kPaddingLarge),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40,
                foregroundImage: NetworkImage(
                  widget.manager.user!.profilePicture.toString(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      Provider.of<AuthManager>(context, listen: false)
                          .signOut(),
                  icon: ColorFiltered(
                    child: Image.asset(
                      'assets/icons/user_light_72.png',
                      height: kIconSizeSmall,
                    ),
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.surface,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text('SIGN_OUT_LABEL'.tr()),
                ),
              ],
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
                  ProfileTextField(
                    label: 'PROFILE_NICKNAME'.tr(),
                    initialValue: nick,
                    onChanged: _onNickChanged,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_EMAIL'.tr(),
                    initialValue: widget.manager.user!.email,
                    readOnly: true,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_BIRTHDAY'.tr(),
                    initialValue: birthday != null
                        ? DateFormat('yyyy. MM. dd.').format(birthday!)
                        : null,
                    onChanged: _onBirthdayChanged,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_PHONENUMBER'.tr(),
                    initialValue: phone,
                    onChanged: _onPhoneChanged,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_GROUPS'.tr(),
                    initialValue: buildGroupNamesFromIDs(
                      widget.manager.user!.groupIDs,
                    ),
                    readOnly: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
              child: Row(
                children: _buildActionButtons(changed),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
