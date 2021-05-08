import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class StoreListWidget extends StatelessWidget {
  const StoreListWidget({Key key, @required this.mapController})
      : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Scaffold(
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                storeNotifier.storeList[index].image != null
                    ? storeNotifier.storeList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 100,
                fit: BoxFit.fitWidth,
              ),
              title: Text(storeNotifier.storeList[index].name),
              subtitle: Text(storeNotifier.storeList[index].address),
              onTap: () async {
                final controller = await mapController.future;
                await controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(
                            storeNotifier.storeList[index].location.latitude,
                            storeNotifier.storeList[index].location.longitude),
                        zoom: 18)));
              },
            );
          },
          itemCount: storeNotifier.storeList.length),
    );
  }
}
