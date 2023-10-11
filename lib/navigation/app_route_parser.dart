import 'package:flutter/material.dart';

import 'app_link.dart';

class SzikAppRouteParser extends RouteInformationParser<SzikAppLink> {
  @override
  Future<SzikAppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    final link =
        SzikAppLink.fromLocation(location: routeInformation.uri.toString());
    return link;
  }

  @override
  RouteInformation restoreRouteInformation(SzikAppLink configuration) {
    final location = configuration.toLocation();

    return RouteInformation(uri: Uri.parse(location));
  }
}
