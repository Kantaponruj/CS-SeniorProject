import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier with ChangeNotifier {
  Geolocator geolocator = Geolocator();
  Position _currentPosition;
  String _currentAddress;
  // Set<Marker> _marker = {};

  static LatLng _initialPosition;

  // getter
  LatLng get initialPosition => _initialPosition;
  Position get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  // Set<Marker> get marker => _marker;

  initialization() async {
    await _determinePosition();
    // await _addMarkerLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await _getUserLocation();
  }

  _getUserLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      // forceAndroidLocationManager: true
    );
    _initialPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = placemarks[0];
    _currentAddress =
        "${place.street}, ${place.locality} ${place.country}, ${place.postalCode}";

    notifyListeners();
  }

  // _addMarkerLocation() async {
  //   _marker.add(Marker(
  //       markerId: MarkerId('currentLocation'),
  //       draggable: true,
  //       position: _initialPosition));
  // }
}
