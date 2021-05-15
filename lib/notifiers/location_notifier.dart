// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationNotifier with ChangeNotifier {
//   Position _currentPosition;
//   String _currentAddress;
//   Set<Marker> _marker = {};

//   static LatLng _initialPosition;

//   // getter
//   LatLng get initialPosition => _initialPosition;
//   Position get currentPosition => _currentPosition;
//   String get currentAddress => _currentAddress;
//   Set<Marker> get marker => _marker;

//   getUserLocation() async {
//     _currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         forceAndroidLocationManager: true);
//     _initialPosition =
//         LatLng(_currentPosition.latitude, _currentPosition.longitude);
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentPosition.latitude, _currentPosition.longitude);
//     Placemark place = placemarks[0];
//     _currentAddress =
//         "${place.street}, ${place.locality} ${place.country}, ${place.postalCode}";
//     notifyListeners();
//   }

//   addMarkerLocation() async {
//     _marker.add(Marker(
//         markerId: MarkerId('currentLocation'),
//         draggable: true,
//         position: _initialPosition));
//   }
// }
