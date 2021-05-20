import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_stores/helper/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier with ChangeNotifier {
  Geolocator geolocator = Geolocator();
  Position _currentPosition;
  String _currentAddress;
  Map<MarkerId, Marker> _marker;
  final MarkerId markerIdUser = MarkerId("userLocation");
  Set<Marker> _markers = {};

  static LatLng _initialPosition;
  // static LatLng _userPosition;
  // static LatLng _storePosition = LatLng(13.6640896, 100.4357021);

  // Set<Polyline> _polylines = Set<Polyline>();
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints;

  // getter
  LatLng get initialPosition => _initialPosition;
  // LatLng get userPosition => _userPosition;
  Position get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  Map<MarkerId, Marker> get marker => _marker;
  Set<Marker> get markers => _markers;
  // Set<Polyline> get polyLines => _polylines;

  LocationNotifier() {
    _marker = <MarkerId, Marker>{};
    // polylinePoints = PolylinePoints();
  }

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

    Marker markerUser = Marker(
      markerId: MarkerId('userLocation'),
      position: LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      ),
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
    );
    _marker[markerIdUser] = markerUser;

    notifyListeners();
  }

  // void setRoutePositions(GeoPoint userPosition) {
  //   _userPosition = LatLng(userPosition.latitude, userPosition.longitude);
  //   _showMarker();
  //   _setPolylines();
  // }

  // void _showMarker() {
  //   _markers.add(Marker(
  //     markerId: MarkerId('sourcePin'),
  //     position: _userPosition,
  //     icon: BitmapDescriptor.defaultMarker,
  //   ));

  //   _markers.add(Marker(
  //     markerId: MarkerId('destinationPin'),
  //     position: _storePosition,
  //     icon: BitmapDescriptor.defaultMarkerWithHue(90),
  //   ));

  //   notifyListeners();
  // }

  // void _setPolylines() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       GOOGLE_MAPS_API_KEY,
  //       PointLatLng(_userPosition.latitude, _userPosition.longitude),
  //       PointLatLng(_storePosition.latitude, _storePosition.longitude));

  //   if (result.status == 'OK') {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });

  //     _polylines.add(Polyline(
  //         width: 5,
  //         polylineId: PolylineId('polyLine'),
  //         color: Color(0xFF08A5CB),
  //         points: polylineCoordinates));
  //   }

  //   notifyListeners();
  // }

  // _addMarkerLocation() {
  // _marker.add(Marker(
  //     markerId: MarkerId('currentLocation'),
  //     draggable: true,
  //     position: _initialPosition));
  // }
}
