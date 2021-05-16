import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/location_notifier.dart';
import 'package:google_map_stores/notifiers/user_notifier.dart';
import 'package:google_map_stores/widgets/loadingWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectMap extends StatefulWidget {
  @override
  _SelectMapState createState() => _SelectMapState();
}

class _SelectMapState extends State<SelectMap> {
  Completer<GoogleMapController> mapController = Completer();

  void initState() {
    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);
    locationNotifier.initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    return Scaffold(
        body: locationNotifier.initialPosition == null
            ? LoadingWidget()
            : Column(children: <Widget>[
                Flexible(
                  flex: 15,
                  child: GoogleMap(
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: locationNotifier.initialPosition,
                        zoom: 18,
                      ),
                      markers: Set<Marker>.of(locationNotifier.marker.values),
                      // {
                      //   Marker(
                      //       markerId: MarkerId('user location'),
                      //       position: locationNotifier.initialPosition,
                      //       draggable: true)
                      // },
                      onMapCreated: (GoogleMapController controller) {
                        mapController.complete(controller);
                      }),
                ),
                SizedBox(height: 12),
                Padding(
                    padding: EdgeInsets.all(30),
                    child: Container(
                        child: Text(locationNotifier.currentAddress))),
                FloatingActionButton.extended(
                  onPressed: () => userNotifier.saveUserLocation(
                      userNotifier.userModel.uid,
                      locationNotifier.currentAddress,
                      locationNotifier.currentPosition),
                  label: Text('Save Location'),
                  icon: Icon(Icons.save),
                ),
              ]));
  }
}
