import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../components.dart';

class SubMenuItemData {
  final String picture;
  final String name;
  final int feature;

  const SubMenuItemData({
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
    return GestureDetector(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              data.picture,
              size: kIconSizeGiant,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: kPaddingNormal),
            Text(
              data.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
