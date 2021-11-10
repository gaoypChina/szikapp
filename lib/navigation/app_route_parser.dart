import 'package:flutter/material.dart';

import 'app_link.dart';

class SzikAppRouteParser extends RouteInformationParser<SzikAppLink> {
  @override
  Future<SzikAppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    final link = SzikAppLink.fromLocation(routeInformation.location);
    return link;
  }

  @override
  RouteInformation restoreRouteInformation(SzikAppLink configuration) {
    final location = configuration.toLocation();

    return RouteInformation(location: location);
  }
}
