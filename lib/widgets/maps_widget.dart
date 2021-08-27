import 'dart:async';
import 'package:cs_senior_project/component/located_FAB.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:cs_senior_project/notifiers/store_notifier.dart';

const _marker = 350.0;

class MapWidget extends StatefulWidget {
  const MapWidget({Key key, @required this.mapController}) : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);
    locationNotifier.initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    Iterable _markers = Iterable.generate(
      storeNotifier.storeList.length,
      (index) {
        return Marker(
          markerId: MarkerId(storeNotifier.storeList[index].storeId),
          icon: BitmapDescriptor.defaultMarkerWithHue(_marker),
          position: LatLng(
            storeNotifier.storeList[index].location.latitude,
            storeNotifier.storeList[index].location.longitude,
          ),
          infoWindow:
              InfoWindow(title: storeNotifier.storeList[index].storeName),
        );
      },
    );

    return locationNotifier.initialPosition == null
        ? LoadingWidget()
        : Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      // target: LatLng(13.655258306757673, 100.49825516513702),
                      target: locationNotifier.initialPosition,
                      zoom: 15),
                  onMapCreated: (GoogleMapController controller) {
                    widget.mapController.complete(controller);
                  },
                  markers: Set.from(_markers),
                ),
              ),
              Positioned(
                right: 20,
                top: 130,
                child: locateFAB(context),
              ),
            ],
          );
  }
}
