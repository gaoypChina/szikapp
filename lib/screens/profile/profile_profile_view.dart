import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class ProfileScreenView extends StatefulWidget {
  final AuthManager manager;

  const ProfileScreenView({
    super.key,
    required this.manager,
  });

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  final _formKey = GlobalKey<FormState>();
  bool _changed = false;
  late String _name;
  String? _nick;
  DateTime? _birthday;
  String? _phone;

  String buildGroupNamesFromIDs({List<String>? ids}) {
    var result = '';
    if (ids == null || ids.isEmpty) return result;
    var groups = Provider.of<SzikAppStateManager>(context).groups;
    if (groups.isEmpty) return result;
    for (var id in ids) {
      result += '${groups.firstWhere((group) => group.id == id).name}, ';
    }
    return result.substring(0, result.length - 2);
  }

  void _onNameChanged(String newValue) {
    setState(() {
      newValue.isEmpty ? _name = widget.manager.user!.name : _name = newValue;
      _changed = true;
    });
  }

  void _onNickChanged(String newValue) {
    setState(() {
      newValue.isEmpty ? _nick = null : _nick = newValue;
      _changed = true;
    });
  }

  void _onPhoneChanged(String newValue) {
    setState(() {
      _phone = newValue;
      _changed = true;
    });
  }

  void _onBirthdayChanged(DateTime newValue) {
    setState(() {
      _birthday = newValue;
      _changed = true;
    });
  }

  Future<void> _onSend() async {
    try {
      if (_formKey.currentState!.validate()) {
        widget.manager.user!.name = _name;
        widget.manager.user!.nick = _nick;
        widget.manager.user!.phone = _phone;
        widget.manager.user!.birthday = _birthday;
        await widget.manager.pushUserUpdate();
        setState(() {
          _changed = false;
        });
        SzikAppState.analytics.logEvent(name: 'profile_update');
      }
    } on NotValidPhoneException {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ERROR_NOT_VALID_PHONE'.tr())));
    }
  }

  void _onCancel() {
    setState(() {
      _name = widget.manager.user!.name;
      _nick = widget.manager.user!.nick;
      _birthday = widget.manager.user!.birthday;
      _phone = widget.manager.user!.phone;
      _changed = false;
    });
    SzikAppState.analytics.logEvent(name: 'profile_update_cancelled');
  }

  List<Widget> _buildDataActionButtons() {
    var theme = Theme.of(context);
    return _changed
        ? [
            ElevatedButton.icon(
              icon: CustomIcon(
                CustomIcons.close,
                size: kIconSizeNormal,
                color: theme.colorScheme.surface,
              ),
              label: Text('BUTTON_DISMISS'.tr()),
              onPressed: _onCancel,
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
            ),
            ElevatedButton.icon(
              icon: CustomIcon(
                CustomIcons.done,
                size: kIconSizeNormal,
                color: theme.colorScheme.surface,
              ),
              label: Text('BUTTON_SAVE'.tr()),
              onPressed: _onSend,
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
            )
          ]
        : [];
  }

  List<Widget> _buildAccountActionButtons() {
    var theme = Theme.of(context);
    return [
      ElevatedButton.icon(
        onPressed: () {
          SzikAppState.analytics.logEvent(name: 'sign_out');
          Provider.of<AuthManager>(context, listen: false).signOut();
        },
        icon: CustomIcon(
          CustomIcons.logout,
          size: kIconSizeSmall,
          color: theme.colorScheme.surface,
        ),
        label: Text('SIGN_OUT_LABEL'.tr()),
        style: ElevatedButton.styleFrom(
          elevation: 0,
        ),
      ),
      ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildAccountDeleteConfirmationDialog(),
          );
        },
        icon: CustomIcon(
          CustomIcons.trash,
          size: kIconSizeSmall,
          color: theme.colorScheme.surface,
        ),
        label: Text('ACCOUNT_DELETE_LABEL'.tr()),
        style: ElevatedButton.styleFrom(
          elevation: 0,
        ),
      ),
    ];
  }

  Widget _buildAccountDeleteConfirmationDialog() {
    return CustomDialog.alert(
      title: 'ACCOUNT_DELETE_DESCRIPTION'.tr(),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        try {
          Provider.of<AuthManager>(context, listen: false).deleteAccount();
          SzikAppState.analytics.logEvent(name: 'profile_delete');
        } on AuthException catch (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorHandler.buildSnackbar(
              context: context,
              errorCode: signInRequiredExceptionCode,
            ),
          );
        }
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _name = widget.manager.user!.name;
    _nick = widget.manager.user?.nick;
    _birthday = widget.manager.user?.birthday;
    _phone = widget.manager.user?.phone;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var userCanModify = widget.manager.user
            ?.hasPermission(permission: Permission.profileEdit) ??
        false;
    var isUserGuest =
        Provider.of<AuthManager>(context, listen: false).isUserGuest;
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'PROFILE_TITLE'.tr(),
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingNormal),
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileTextField(
                    label: 'PROFILE_NAME'.tr(),
                    initialValue: _name,
                    onChanged: _onNameChanged,
                    readOnly: !userCanModify,
                  ),
                  if (!isUserGuest)
                    ProfileTextField(
                      label: 'PROFILE_NICKNAME'.tr(),
                      initialValue: _nick,
                      onChanged: _onNickChanged,
                      readOnly: !userCanModify,
                    ),
                  ProfileTextField(
                    label: 'PROFILE_EMAIL'.tr(),
                    initialValue: widget.manager.user?.email,
                    readOnly: true,
                  ),
                  if (!isUserGuest)
                    ProfileDateField(
                      label: 'PROFILE_BIRTHDAY'.tr(),
                      initialValue: _birthday,
                      onChanged: _onBirthdayChanged,
                      readOnly: !userCanModify,
                    ),
                  if (!isUserGuest)
                    ProfileTextField(
                      label: 'PROFILE_PHONENUMBER'.tr(),
                      initialValue: _phone,
                      onChanged: _onPhoneChanged,
                      readOnly: !userCanModify,
                    ),
                  if (!isUserGuest)
                    ProfileTextField(
                      label: 'PROFILE_GROUPS'.tr(),
                      initialValue: buildGroupNamesFromIDs(
                        ids: widget.manager.user?.groupIDs,
                      ),
                      readOnly: true,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kPaddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: userCanModify ? _buildDataActionButtons() : [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kPaddingNormal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildAccountActionButtons(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
                child: Link(
                  uri: Uri.parse(
                      'https://szikapp.netlify.app/privacy_policy.html'),
                  target: LinkTarget.defaultTarget,
                  builder: (context, followLink) {
                    return InkWell(
                      onTap: followLink,
                      child: Text(
                        'PRIVACY_POLICY_LINK'.tr(),
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.secondaryContainer,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
