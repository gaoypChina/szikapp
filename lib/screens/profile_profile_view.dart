import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/permission.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

class ProfileScreenView extends StatefulWidget {
  final AuthManager manager;

  const ProfileScreenView({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  final _formKey = GlobalKey<FormState>();
  bool changed = false;
  bool error = false;
  String? nick;
  DateTime? birthday;
  String? phone;

  String buildGroupNamesFromIDs(List<String>? ids) {
    var result = '';
    if (ids == null || ids.isEmpty) return result;
    var groups =
        Provider.of<SzikAppStateManager>(context, listen: false).groups;
    if (groups.isEmpty) return result;
    for (var id in ids) {
      result += '${groups.firstWhere((element) => element.id == id).name}, ';
    }
    return result.substring(0, result.length - 2);
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

  List<Widget> _buildActionButtons() {
    return changed
        ? [
            ElevatedButton.icon(
              icon: const CustomIcon(
                CustomIcons.close,
                size: kIconSizeNormal,
              ),
              label: Text('BUTTON_DISMISS'.tr()),
              onPressed: _onCancel,
            ),
            ElevatedButton.icon(
              icon: const CustomIcon(
                CustomIcons.done,
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
    nick = widget.manager.user?.nick;
    birthday = widget.manager.user?.birthday;
    phone = widget.manager.user?.phone;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var userCanModify =
        widget.manager.user?.hasPermission(Permission.profileEdit) ?? false;
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'PROFILE_TITLE'.tr(),
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: kPaddingLarge),
              alignment: Alignment.center,
              child: widget.manager.user?.profilePicture != null
                  ? CircleAvatar(
                      radius: 40,
                      foregroundImage: NetworkImage(
                        widget.manager.user!.profilePicture!,
                      ),
                    )
                  : CustomIcon(
                      CustomIcons.user,
                      size: kIconSizeGiant,
                      color: theme.colorScheme.primary,
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      Provider.of<AuthManager>(context, listen: false)
                          .signOut(),
                  icon: CustomIcon(
                    CustomIcons.logout,
                    size: kIconSizeSmall,
                    color: theme.colorScheme.surface,
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
                    initialValue: widget.manager.user?.name,
                    readOnly: true,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_NICKNAME'.tr(),
                    initialValue: nick,
                    onChanged: _onNickChanged,
                    readOnly: !userCanModify,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_EMAIL'.tr(),
                    initialValue: widget.manager.user?.email,
                    readOnly: true,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_BIRTHDAY'.tr(),
                    initialValue: birthday != null
                        ? DateFormat('yyyy. MM. dd.').format(birthday!)
                        : null,
                    onChanged: _onBirthdayChanged,
                    readOnly: !userCanModify,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_PHONENUMBER'.tr(),
                    initialValue: phone,
                    onChanged: _onPhoneChanged,
                    readOnly: !userCanModify,
                  ),
                  ProfileTextField(
                    label: 'PROFILE_GROUPS'.tr(),
                    initialValue: buildGroupNamesFromIDs(
                      widget.manager.user?.groupIDs,
                    ),
                    readOnly: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: userCanModify ? _buildActionButtons() : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
