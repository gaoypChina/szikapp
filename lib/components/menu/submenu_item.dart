import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';

class SubMenuItemData {
  final String picture;
  final String name;
  final int feature;

  SubMenuItemData({
    required this.picture,
    required this.name,
    required this.feature,
  });
}

class SubMenuItem extends StatelessWidget {
  final SubMenuItemData data;

  const SubMenuItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: GestureDetector(
        onTap: () {
          Provider.of<SzikAppStateManager>(context, listen: false)
              .selectFeature(data.feature);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusNormal),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 25, 0, 8),
                height: 55,
                width: 55,
                child: ColorFiltered(
                  child: Image.asset(data.picture),
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
