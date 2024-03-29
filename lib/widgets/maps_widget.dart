// import 'dart:typed_data';
// import 'dart:ui' as ui;
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:provider/provider.dart';

import 'package:cs_senior_project/notifiers/store_notifier.dart';

const _marker = 350.0;

class MapWidget extends StatefulWidget {
  const MapWidget({Key key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);
    locationNotifier.initialization();
    // setCustomMapPin();
    setSourceAndDestinationIcons();
    super.initState();
  }

  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  // }

  // Uint8List foodStallIcon;
  // Uint8List foodTruckIcon;

  BitmapDescriptor foodStallIcon;
  BitmapDescriptor foodTruckIcon;

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(8, 8)),
      'assets/images/marker_foodstall.png',
    ).then((d) {
      foodStallIcon = d;
    });

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(8, 8)),
      'assets/images/marker_foodtruck.png',
    ).then((d) {
      foodTruckIcon = d;
    });
  }

  // void setCustomMapPin() async {
  //   foodStallIcon = await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(),
  //     'assets/images/marker_foodstall.png',
  //   );
  //   foodTruckIcon = await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(),
  //     'assets/images/marker_foodtruck.png',
  //   );
  //   // pinLocationIcon = await BitmapDescriptor.fromAssetImage(
  //   //     ImageConfiguration(devicePixelRatio: 0.5,),
  //   //     'assets/images/marker_foodstall.png', );
  // }

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
          // icon: store.typeOfStore == 'ร้านค้ารถเข็น' ? foodStallIcon : foodTruckIcon,
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

    return locationNotifier.initialPosition == null
        ? LoadingWidget()
        : Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: GoogleMap(
                  padding: EdgeInsets.only(bottom: 200),
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: locationNotifier.initialPosition,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    locationNotifier.mapController = controller;
                  },
                  markers: Set.from(_markers),
                ),
              ),
            ],
          );
  }
}
