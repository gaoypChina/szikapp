import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class CleaningParticipantsView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningParticipantsView({super.key, required this.manager});

  @override
  State<CleaningParticipantsView> createState() =>
      _CleaningParticipantsViewState();
}

class _CleaningParticipantsViewState extends State<CleaningParticipantsView> {
  List<String> _groupIDs = [];
  List<String> _blackListGroup = [];
  List<String> _blackListUser = [];
  List<String> _whiteListUser = [];
  bool _modified = false;

  @override
  void initState() {
    super.initState();
    _groupIDs = widget.manager.cleaningParticipants.groupIDs;
    _blackListGroup = widget.manager.cleaningParticipants.blackListGroup;
    _blackListUser = widget.manager.cleaningParticipants.blackListUser;
    _whiteListUser = widget.manager.cleaningParticipants.whiteListUser;
  }

  void _onGroupIDsChanged(List<Group>? newGroups) {
    setState(() {
      _groupIDs = newGroups?.map((group) => group.id).toList() ?? [];
      _modified = true;
    });
  }

  void _onBlackListGroupChanged(List<Group>? newBlackListGroup) {
    setState(() {
      _blackListGroup =
          newBlackListGroup?.map((group) => group.id).toList() ?? [];
      _modified = true;
    });
  }

  void _onBlackListUserChanged(List<User>? newBlackListUser) {
    setState(() {
      _blackListUser = newBlackListUser?.map((user) => user.id).toList() ?? [];
      _modified = true;
    });
  }

  void _onWhiteListUserChanged(List<User>? newWhiteListUser) {
    setState(() {
      _whiteListUser = newWhiteListUser?.map((user) => user.id).toList() ?? [];
      _modified = true;
    });
  }

  Widget _buildOnSaveDialog() {
    var newParticipantData = CleaningParticipants(
      groupIDs: _groupIDs,
      blackListGroup: _blackListGroup,
      blackListUser: _blackListUser,
      whiteListUser: _whiteListUser,
      lastUpdate: DateTime.now(),
    );
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_PARTICIPANTS_TITLE'.tr(),
      bodytext: 'CLEANING_DIALOG_PARTICIPANTS_TEXT'.tr(),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        try {
          widget.manager
              .editCleaningParticipants(newParticipantData: newParticipantData);
          SzikAppState.analytics.logEvent(name: 'cleaning_participants_edit');
          setState(() {
            _modified = false;
          });
          Navigator.of(context, rootNavigator: true).pop();
        } on IOException catch (exception) {
          var snackbar = ErrorHandler.buildSnackbar(
              context: context, exception: exception);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
    );
  }

  void _onCancel() {
    SzikAppState.analytics.logEvent(name: 'cleaning_participants_edit_cancel');
    setState(() {
      _groupIDs = widget.manager.cleaningParticipants.groupIDs;
      _blackListGroup = widget.manager.cleaningParticipants.blackListGroup;
      _blackListUser = widget.manager.cleaningParticipants.blackListUser;
      _whiteListUser = widget.manager.cleaningParticipants.whiteListUser;
      _modified = false;
    });
  }

  List<Widget> _buildDataActionButtons() {
    var theme = Theme.of(context);
    return _modified
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
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => _buildOnSaveDialog(),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
            )
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appStateManager =
        Provider.of<SzikAppStateManager>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
            child: Text(
              'CLEANING_ADMIN_PARTICIPANT_GROUPS'.tr(),
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: theme.colorScheme.primaryContainer),
            ),
          ),
          SearchableOptions<Group>.multiSelection(
            items: appStateManager.groups,
            selectedItems: appStateManager.groups
                .where(
                  (group) => _groupIDs.contains(group.id),
                )
                .toList(),
            onItemsChanged: _onGroupIDsChanged,
            compare: (i, s) => i!.isEqual(s),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
            child: Text(
              'CLEANING_ADMIN_BLACKLIST_GROUPS'.tr(),
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: theme.colorScheme.primaryContainer),
            ),
          ),
          SearchableOptions<Group>.multiSelection(
            items: appStateManager.groups,
            selectedItems: appStateManager.groups
                .where(
                  (group) => _blackListGroup.contains(group.id),
                )
                .toList(),
            onItemsChanged: _onBlackListGroupChanged,
            compare: (i, s) => i!.isEqual(s),
            nullValidated: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
            child: Text(
              'CLEANING_ADMIN_BLACKLIST_USERS'.tr(),
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: theme.colorScheme.primaryContainer),
            ),
          ),
          SearchableOptions<User>.multiSelection(
            items: appStateManager.users,
            selectedItems: appStateManager.users
                .where(
                  (user) => _blackListUser.contains(user.id),
                )
                .toList(),
            onItemsChanged: _onBlackListUserChanged,
            compare: (i, s) => i!.isEqual(s),
            nullValidated: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
            child: Text(
              'CLEANING_ADMIN_WHITELIST_USERS'.tr(),
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: theme.colorScheme.primaryContainer),
            ),
          ),
          SearchableOptions<User>.multiSelection(
            items: appStateManager.users,
            selectedItems: appStateManager.users
                .where(
                  (group) => _whiteListUser.contains(group.id),
                )
                .toList(),
            onItemsChanged: _onWhiteListUserChanged,
            compare: (i, s) => i!.isEqual(s),
            nullValidated: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: kPaddingLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildDataActionButtons(),
            ),
          ),
        ],
      ),
    );
  }
}
