import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';

class ReservationPlacesScreen extends StatelessWidget {
  static const String route = '/reservation/places';
  final ReservationManager manager;

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationPlacesScreen(manager: manager),
    );
  }

  const ReservationPlacesScreen({
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    var places =
        Provider.of<SzikAppStateManager>(context, listen: false).places;
    return CustomFutureBuilder(
      future: manager.refresh(),
      shimmer: const ListScreenShimmer(),
      child: CustomScaffold(
        appBarTitle: 'RESERVATION_MAP_TITLE'.tr(),
        body: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            var reserved = manager.isReserved(places[index].id);
            return places[index].type == PlaceType.public
                ? ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(
                      places[index].name,
                    ),
                    onTap: () =>
                        Provider.of<ReservationManager>(context, listen: false)
                            .selectPlace(index),
                    trailing: IconButton(
                      tooltip: reserved
                          ? 'RESERVATION_CURRENTLY_RESERVED'.tr()
                          : 'RESERVATION_CURRENTLY_FREE'.tr(),
                      icon: Icon(
                        reserved ? Icons.event_busy : Icons.event_available,
                        color: reserved
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                      onPressed: () => {},
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }
}
