import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../ui/themes.dart';
import 'components.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Type typeToCreate;
  final String icon;

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.typeToCreate,
    this.icon = CustomIcons.plus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthManager>(context, listen: false).user;
    return user!.hasPermissionToCreate(typeToCreate)
        ? FloatingActionButton(
            onPressed: onPressed,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(
                width: kIconSizeLarge,
                height: kIconSizeLarge,
              ),
              child: CustomIcon(icon),
            ),
          )
        : Container();
  }
}
