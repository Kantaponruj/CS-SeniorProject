import 'dart:async';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
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
        final store = storeNotifier.storeList[index];
        return Marker(
          markerId: MarkerId(store.storeId),
          icon: BitmapDescriptor.defaultMarkerWithHue(_marker),
          position: LatLng(
            store.realtimeLocation != null
                ? store.realtimeLocation.latitude
                : store.location.latitude,
            store.realtimeLocation != null
                ? store.realtimeLocation.longitude
                : store.location.longitude,
          ),
          infoWindow: InfoWindow(title: store.storeName),
        );
      },
    );
    // setState(() {});

    return locationNotifier.initialPosition == null
        ? LoadingWidget()
        : Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: locationNotifier.initialPosition,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    widget.mapController.complete(controller);
                  },
                  markers: Set.from(_markers),
                ),
              ),
            ],
          );
  }
}

// class MapRealtimeWidget extends StatefulWidget {
//   MapRealtimeWidget({Key key, @required this.order, @required this.isPreview})
//       : super(key: key);
//   final order;
//   final bool isPreview;
//
//   @override
//   _MapRealtimeWidgetState createState() => _MapRealtimeWidgetState();
// }
//
// class _MapRealtimeWidgetState extends State<MapWidget> {
//
//   @override
//   void initState() {
//     LocationNotifier locationNotifier =
//     Provider.of<LocationNotifier>(context, listen: false);
//     locationNotifier.initialization();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);
//
//     final routeColor = CollectionsColors.navy;
//     final routeWidth = 5;
//     final storeName = "จุดเริ่มต้น";
//     final customerName = "ลูกค้า";
//     final driverName = "ฉัน";
//     final storeIcon = "assets/images/restaurant-marker-icon.png";
//     final customerIcon = "assets/images/house-marker-icon.png";
//     final driverIcon = "assets/images/driver-marker-icon.png";
//     // final storeLocation = LatLng(
//     //   store.store.realtimeLocation.latitude,
//     //   store.store.realtimeLocation.longitude,
//     // );
//     // final customerLocation = LatLng(
//     //   double.parse(widget.order['geoPoint'].latitude.toString()),
//     //   double.parse(widget.order['geoPoint'].longitude.toString()),
//     // );
//
//     return MaterialApp(
//       home: SafeArea(
//           child: Scaffold(
//             body: GoogleMapsWidget(
//               apiKey: GOOGLE_MAPS_API_KEY,
//               sourceLatLng: LatLng(
//                 store.realtimeLocation.latitude,
//                 store.realtimeLocation.longitude,
//               ),
//               destinationLatLng: LatLng(
//                 double.parse(widget.order['geoPoint'].latitude.toString()),
//                 double.parse(widget.order['geoPoint'].longitude.toString()),
//               ),
//               routeWidth: routeWidth,
//               routeColor: routeColor,
//               sourceMarkerIconInfo: MarkerIconInfo(
//                 assetPath: storeIcon,
//                 assetMarkerSize: Size.square(125),
//               ),
//               destinationMarkerIconInfo: MarkerIconInfo(
//                 assetPath: customerIcon,
//               ),
//               driverMarkerIconInfo: MarkerIconInfo(
//                 assetPath: driverIcon,
//               ),
//               driverCoordinatesStream: Stream.periodic(
//                 Duration(milliseconds: 500),
//                     (i) {
//                   store.reloadUserModel();
//                   return LatLng(
//                     store.store.realtimeLocation.latitude,
//                     store.store.realtimeLocation.longitude,
//                   );
//                 },
//               ),
//               sourceName: storeName,
//               destinationName: customerName,
//               driverName: driverName,
//               totalTimeCallback: (time) => print(time),
//               totalDistanceCallback: (distance) => print(distance),
//             ),
//           )
//       ),);
//   }
// }
