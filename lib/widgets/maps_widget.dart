import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:cs_senior_project/notifiers/store_notifier.dart';

const _marker = 350.0;

class MapWidget extends StatelessWidget {
  const MapWidget({Key key, @required this.mapController}) : super(key: key);
  final Completer<GoogleMapController> mapController;

  // String latitude;
  // String longtitude;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    Iterable _markers =
        Iterable.generate(storeNotifier.storeList.length, (index) {
      return Marker(
          markerId: MarkerId(storeNotifier.storeList[index].storeId),
          icon: BitmapDescriptor.defaultMarkerWithHue(_marker),
          position: LatLng(
            storeNotifier.storeList[index].location.latitude,
            storeNotifier.storeList[index].location.longitude,
          ),
          infoWindow:
              InfoWindow(title: storeNotifier.storeList[index].storeName));
    });

    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(13.655258306757673, 100.49825516513702), zoom: 15),
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
      markers: Set.from(_markers),
    );
  }
  //
  // void getCurrentLocation() async {
  //   var position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   var lat = position.latitude;
  //   var long = position.longitude;
  //
  //   latitude = "$lat";
  //   longtitude = "$long";
  //
  // }
}
