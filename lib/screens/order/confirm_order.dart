import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class ConfirmedOrderMapPage extends StatefulWidget {
  const ConfirmedOrderMapPage({Key key}) : super(key: key);

  @override
  _ConfirmedOrderMapPageState createState() => _ConfirmedOrderMapPageState();
}

class _ConfirmedOrderMapPageState extends State<ConfirmedOrderMapPage> {
  Completer<GoogleMapController> _mapController = Completer();

  Set<Marker> _markers = Set<Marker>();
  LatLng customerLocation;
  LatLng storeLocation;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  String customerName;
  String storeName;

  @override
  void initState() {
    polylinePoints = PolylinePoints();
    this.setInitialLocation();
    orderStatus = false;
    checkStatus();
    super.initState();
  }

  void setInitialLocation() {
    ActivitiesNotifier activitiesNotifier =
        Provider.of<ActivitiesNotifier>(context, listen: false);
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    customerLocation = LatLng(
      activitiesNotifier.currentActivity.geoPoint.latitude,
      activitiesNotifier.currentActivity.geoPoint.longitude,
    );
    storeLocation = LatLng(
      storeNotifier.currentStore.location.latitude,
      storeNotifier.currentStore.location.longitude,
    );

    customerName = activitiesNotifier.currentActivity.customerName;
    storeName = storeNotifier.currentStore.storeName;
  }

  void showMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('Customer Marker'),
        position: customerLocation,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Home"),
      ));

      _markers.add(Marker(
        markerId: MarkerId('Store Marker'),
        position: storeLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
      ));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(customerLocation.latitude, customerLocation.longitude),
      PointLatLng(
        storeLocation.latitude,
        storeLocation.longitude,
      ),
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
          width: 5,
          polylineId: PolylineId('polyLine'),
          // color: Color(0xFF08A5CB),
          points: polylineCoordinates,
        ));
      });
    }
  }

  Future<void> checkStatus() async {
    ActivitiesNotifier activitiesNotifier =
    Provider.of<ActivitiesNotifier>(context, listen: false);
    if(activitiesNotifier.currentActivity.orderStatus == 'จัดส่งเรียบร้อยแล้ว') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => bottomBar()));
    }
    Future.delayed(Duration(seconds: 2), () {
      checkStatus();
      print('check');
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activitiesNotifier =
        Provider.of<ActivitiesNotifier>(context);

    final orderDetailHeight = MediaQuery.of(context).size.height / 3;
    final mapHeight = MediaQuery.of(context).size.height - (orderDetailHeight);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTitle: 'สถานะการจัดส่ง',
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
          child: Stack(
            children: [
              Container(
                height: mapHeight,
                child: GoogleMap(
                  myLocationEnabled: true,
                  compassEnabled: false,
                  tiltGesturesEnabled: false,
                  polylines: _polylines,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    showMarker();
                    setPolylines();
                  },
                  initialCameraPosition: CameraPosition(
                    target: customerLocation,
                    zoom: 13,
                  ),
                ),
              ),
              information(
                orderDetailHeight,
                mapHeight,
                activitiesNotifier.currentActivity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget information(
      double orderDetailHeight, double mapHeight, Activities activity) {
    return Container(
      height: orderDetailHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: mapHeight - 20),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    'ยืนยันคำสั่งซื้อ',
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
                Container(
                  child: Text(
                    'จะได้รับในเวลา 16.30',
                    style: FontCollection.topicTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: activity.storeImage.isNotEmpty
                          ? NetworkImage(
                              activity.storeImage,
                              // fit: BoxFit.cover,
                              // width: double.infinity,
                              // height: double.infinity,
                            )
                          : AssetImage(
                              'assets/images/shop_test.jpg',
                              // fit: BoxFit.cover,
                              // width: double.infinity,
                              // height: double.infinity,
                            ),
                      radius: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                activity.storeName,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    orderFinish = true;
                                    orderedMenu = false;
                                  });
                                  Navigator.of(context)
                                      .pushNamed('/orderDetail');
                                },
                                child: Text(
                                  'รายละเอียด',
                                  style: FontCollection.underlineButtonTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                activity.kindOfFood,
                                style: FontCollection.descriptionTextStyle,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${activity.netPrice} บาท',
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         flex: 3,
          //         child: Container(
          //           child: Text(
          //             'เวลาสั่งซื้อ',
          //             style: FontCollection.bodyTextStyle,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 6,
          //         child: Container(
          //           margin: EdgeInsets.only(left: 10),
          //           child: Text(
          //             activity.dateOrdered,
          //             style: FontCollection.bodyTextStyle,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 3,
          //         child: Container(
          //           child: Text(
          //             '${activity.timeOrdered} น.',
          //             style: FontCollection.bodyTextStyle,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         flex: 3,
          //         child: Container(
          //           child: Text(
          //             'สถานที่',
          //             style: FontCollection.bodyTextStyle,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 9,
          //         child: Container(
          //           margin: EdgeInsets.only(left: 10),
          //           child: AutoSizeText(
          //             activity.address,
          //             style: FontCollection.bodyTextStyle,
          //             maxLines: 2,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          StadiumButtonWidget(
            text: activity.orderStatus == 'จัดส่งเรียบร้อยแล้ว'
                ? 'กลับหน้าโฮม'
                : 'โทร',
            onClicked: () {
              setState(() {
                if (activity.orderStatus == 'จัดส่งเรียบร้อยแล้ว') {
                  orderStatus = true;
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => bottomBar()));
                }
              });
            },
          ),
        ],
      ),
    );
  }

  bool orderStatus = false;
}
