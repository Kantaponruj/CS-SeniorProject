import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_stores/notifiers/auth_notifier.dart';
import 'package:google_map_stores/services/databaseService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectMap extends StatefulWidget {
  @override
  _SelectMapState createState() => _SelectMapState();
}

class _SelectMapState extends State<SelectMap> {
  Completer<GoogleMapController> mapController = Completer();
  Position currentPosition;
  String currentAddress;
  List<Marker> marker = [];

  static LatLng _initialPosition;

  void initState() {
    _getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
        body: _initialPosition == null
            ? Container(
                child: Center(
                  child: Text(
                    'loading map..',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              )
            : Column(children: <Widget>[
                Flexible(
                  flex: 5,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 17,
                    ),
                    markers: Set.from(marker),
                    onMapCreated: (GoogleMapController controller) {
                      mapController.complete(controller);
                    },
                    // onCameraMove: _onCameraMove,
                  ),
                ),
                SizedBox(height: 12),
                if (currentAddress != null) Text(currentAddress),
                Flexible(flex: 1, child: Container(child: _getUserLocation())),
                FloatingActionButton.extended(
                  onPressed: () => updateUserLocation(
                      authNotifier.user.uid, currentPosition),
                  label: Text('Save Location'),
                  icon: Icon(Icons.save),
                )
              ]));
  }

  _getUserLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        _initialPosition =
            LatLng(currentPosition.latitude, currentPosition.longitude);
        _getMarkerLocation();
        _getAddressFromLatLng();
      });
    });
  }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  _getMarkerLocation() async {
    setState(() {
      marker.add(Marker(
          markerId: MarkerId('currentLocation'),
          draggable: true,
          position: _initialPosition));
    });
  }

  _getAddressFromLatLng() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemarks[0];

    setState(() {
      currentAddress =
          "${place.street}, ${place.locality} ${place.country}, ${place.postalCode}";
    });
  }
}
