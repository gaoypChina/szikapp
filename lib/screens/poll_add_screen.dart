import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';

class PollAddScreen extends StatelessWidget {
  static const String route = '/poll'; //?

  static MaterialPage page({required PollManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: PollAddScreen(manager: manager),
    );
  }

  final PollManager manager;

  const PollAddScreen({
    Key key = const Key('PollAddScreen'),
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
      shimmer: const TileShimmer(),
      child: PollAddView(manager: manager),
    );
  }
}

class PollAddView extends StatefulWidget {
  final PollManager manager;

  const PollAddView({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  _PollAddViewState createState() => _PollAddViewState();
}

class _PollAddViewState extends State<PollAddView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return CustomScaffold(
      appBarTitle: 'POLL_TITLE'.tr(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                      color: theme.colorScheme.primary),
                  child: Text(
                    'POLL_ADD'.tr(),
                    style: theme.textTheme.subtitle1
                        ?.copyWith(color: theme.colorScheme.surface),
                  ),
                ),
                //kérdés
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'POLL_WRITE_QUESTION'.tr(),
                  ),
                  maxLines: 2,
                  minLines: 1,
                ),
                //szavazás leírása
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'POLL_DESCRIPTION'.tr(),
                  ),
                  maxLines: 5,
                  minLines: 1,
                ),
                //választási lehetőségek
                Text(
                  'POLL_OPTIONS'.tr(),
                  style: theme.textTheme.subtitle1
                      ?.copyWith(color: theme.colorScheme.primaryContainer),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '...',
                  ),
                ),

                FloatingActionButton(
                  //középre
                  onPressed: _onAddOption,
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints.expand(width: 36, height: 36),
                    child: Image.asset('assets/icons/plus_light_72.png'),
                  ),
                ),

                Text(
                  'POLL_DURATION'.tr(),
                  style: theme.textTheme.subtitle1
                      ?.copyWith(color: theme.colorScheme.primaryContainer),
                ),

                //dátumok kiválasztása
                TextFormField(
                    //controller: dateCtl,
                    decoration: const InputDecoration(
                        //hintText: '',
                        ),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                    }
                    //dateCtl.text = date.toIso8601String();},)
                    ),

                Text(
                  'POLL_PARTICIPANTS'.tr(),
                  style: theme.textTheme.subtitle1
                      ?.copyWith(color: theme.colorScheme.primaryContainer),
                ),

                SearchableOptions<Group>(
                    items:
                        Provider.of<SzikAppStateManager>(context, listen: false)
                            .groups,
                    onItemChanged: _onItemChanged,
                    compare: (i, s) => i!.isEqual(s))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAddOption() {}

  void _onItemChanged(Group? value) {}
}
