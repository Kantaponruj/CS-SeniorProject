import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:provider/provider.dart';

class MapConfirmedWidet extends StatelessWidget {
  const MapConfirmedWidet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);
    StoreNotifier store = Provider.of<StoreNotifier>(context);

    final routeColor = CollectionsColors.navy;
    final routeWidth = 5;
    final storeName = "จุดเริ่มต้น";
    final customerName = "ฉัน";
    final driverName = "ร้านค้า";
    final storeIcon = "assets/images/restaurant-marker-icon.png";
    final customerIcon = "assets/images/house-marker-icon.png";
    final driverIcon = "assets/images/driver-marker-icon.png";

    return GoogleMapsWidget(
      apiKey: GOOGLE_MAPS_API_KEY,
      sourceLatLng: LatLng(
        store.currentStore.realtimeLocation.latitude,
        store.currentStore.realtimeLocation.longitude,
      ),
      destinationLatLng: LatLng(
        activity.currentActivity.geoPoint.latitude,
        activity.currentActivity.geoPoint.longitude,
      ),
      routeWidth: routeWidth,
      routeColor: routeColor,
      sourceMarkerIconInfo: MarkerIconInfo(
        assetPath: storeIcon,
        assetMarkerSize: Size.square(125),
      ),
      destinationMarkerIconInfo: MarkerIconInfo(
        assetPath: customerIcon,
      ),
      driverMarkerIconInfo: MarkerIconInfo(
        assetPath: driverIcon,
      ),
      driverCoordinatesStream: Stream.periodic(
        Duration(milliseconds: 500),
        (i) {
          return LatLng(
            store.currentStore.realtimeLocation.latitude,
            store.currentStore.realtimeLocation.longitude,
          );
        },
      ),
      sourceName: storeName,
      destinationName: customerName,
      driverName: driverName,
      totalTimeCallback: (time) => print(time),
      totalDistanceCallback: (distance) => print(distance),
    );
  }
}
