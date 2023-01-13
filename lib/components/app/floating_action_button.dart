import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../ui/themes.dart';
import '../components.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Type typeToCreate;

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.typeToCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthManager>(context, listen: false).user;
    return user!.hasPermissionToCreate(typeToCreate)
        ? FloatingActionButton(
            onPressed: onPressed,
            elevation: 0,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(
                width: kIconSizeLarge,
                height: kIconSizeLarge,
              ),
              child: const CustomIcon(CustomIcons.plus),
            ),
          )
        : Container();
  }
}
