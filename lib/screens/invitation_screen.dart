import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../utils/utils.dart';

class InvitationScreen extends StatelessWidget {
  static const String route = '/invitation';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: InvitationScreen(),
    );
  }

  const InvitationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: IO.instance.getInvitations(),
      child: CustomScaffold(
        appBarTitle: 'INVITATION_TITLE'.tr(),
      ),
    );
  }
}
