import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../screens.dart';

class InvitationScreen extends StatelessWidget {
  static const String route = '/invitation';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: InvitationScreen(),
    );
  }

  const InvitationScreen({super.key = const Key('InvitationScreen')});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TimetableTask>>(
      future: IO.instance.getInvitations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListScreenShimmer();
        } else if (snapshot.hasError) {
          if (SzikAppState.connectionStatus == ConnectivityResult.none) {
            return ErrorScreen(
              errorInset: ErrorHandler.buildInset(
                context: context,
                errorCode: noConnectionExceptionCode,
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          var invitations = snapshot.data!;
          return CustomScaffold(
            appBarTitle: 'INVITATION_TITLE'.tr(),
            body: ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) =>
                  InvitationCard(data: invitations[index]),
            ),
          );
        }
      },
    );
  }
}
