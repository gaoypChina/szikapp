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
  static const String route = '/poll/new';

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
    return PollAddView(
      manager: manager,
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
      body: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
          border: Border.all(
            color: theme.colorScheme.primary,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(4, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            //fejlélc
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'POLL_ADD'.tr(),
                  style: theme.textTheme.subtitle1?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),

            //tartalom
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingNormal),
                child: ListView(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          hintText: 'POLL_WRITE_QUESTION'.tr(),
                        ),
                        maxLines: 2,
                        minLines: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    //szavazás leírása
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          hintText: 'POLL_DESCRIPTION'.tr(),
                        ),
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                    //választási lehetőségek
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        'POLL_OPTIONS'.tr(),
                        style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.primaryContainer),
                      ),
                    ),

                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          hintText: 'POLL_ANSWER_OPTION'.tr(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          onPressed: _onAddOption,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.expand(
                                width: 36, height: 36),
                            child:
                                Image.asset('assets/icons/plus_light_72.png'),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        'POLL_DURATION'.tr(),
                        style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.primaryContainer),
                      ),
                    ),

                    //dátumok kiválasztása
                    Expanded(
                      child: TextFormField(
                        //controller: dateCtl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
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
                        },
                        //dateCtl.text = date.toIso8601String();},)
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        'POLL_PARTICIPANTS'.tr(),
                        style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.primaryContainer),
                      ),
                    ),

                    SearchableOptions<Group>(
                        items: Provider.of<SzikAppStateManager>(context,
                                listen: false)
                            .groups,
                        onItemChanged: _onItemChanged,
                        compare: (i, s) => i!.isEqual(s)),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'POLL_SECRET'.tr(),
                            style: theme.textTheme.subtitle1?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                                value: true,
                                onChanged: _onSecretPollChanged,
                                activeColor: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'POLL_MULTIPLE_CHOICE'.tr(),
                            style: theme.textTheme.subtitle1?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: true,
                              onChanged: _onMultipleChoiceChanged,
                              activeColor: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'POLL_MAX_OPTIONS'.tr(),
                            style: theme.textTheme.subtitle1?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                          ),
                          Expanded(
                            child: TextFormField(
                              //itt mi történik?
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      kBorderRadiusNormal),
                                ),
                                hintText: '...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        'POLL_FEEDBACK'.tr(),
                        style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.primaryContainer),
                      ),
                    ),

                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          hintText: 'POLL_THANKS'.tr(),
                        ),
                      ),
                    ),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //kuka ikon
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              child: Text(
                                'POLL_CREATE'.tr(),
                              ),
                              color: theme.colorScheme.secondary,
                              textColor: theme.colorScheme.surface,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddOption() {}

  void _onItemChanged(Group? value) {}

  void _onSecretPollChanged(bool value) {}

  void _onMultipleChoiceChanged(bool value) {}
}
