import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_stores/helper/constant.dart';
import 'package:google_map_stores/notifiers/user_notifier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const LatLng SOURCE_LOCATION = LatLng(13.652720, 100.493635);
const LatLng DEST_LOCATION = LatLng(13.6640896, 100.4357021);

class Direction extends StatefulWidget {
  @override
  _DirectionState createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  Completer<GoogleMapController> mapController = Completer();

  Set<Marker> _markers = Set<Marker>();
  LatLng currentLocation;
  LatLng destinationLocation;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  @override
  void initState() {
    // UserNotifier userNotifier =
    //     Provider.of<UserNotifier>(context, listen: false);
    // LocationNotifier locationNotifier =
    //     Provider.of<LocationNotifier>(context, listen: false);
    // locationNotifier.setRoutePositions(userNotifier.userModel.realtimeLocation);
    super.initState();
    polylinePoints = PolylinePoints();
    this.setInitialLocation();
  }

  void setInitialLocation() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    currentLocation = LatLng(userNotifier.userModel.realtimeLocation.latitude,
        userNotifier.userModel.realtimeLocation.longitude);
    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    // LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Direction"),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        compassEnabled: false,
        tiltGesturesEnabled: false,
        polylines: _polylines,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
          showMarker();
          setPolylines();
        },
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 13,
        ),
      ),
    );
  }

  void showMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: currentLocation,
        icon: BitmapDescriptor.defaultMarker,
      ));

      _markers.add(Marker(
        markerId: MarkerId('destinationPin'),
        position: destinationLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
      ));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 5,
            polylineId: PolylineId('polyLine'),
            color: Color(0xFF08A5CB),
            points: polylineCoordinates));
      });
    }
  }
}
