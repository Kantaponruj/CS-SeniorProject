import 'dart:async';

import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:provider/provider.dart';

class ConfirmedOrderMapPage extends StatefulWidget {
  const ConfirmedOrderMapPage({Key key}) : super(key: key);

  @override
  _ConfirmedOrderMapPageState createState() => _ConfirmedOrderMapPageState();
}

class _ConfirmedOrderMapPageState extends State<ConfirmedOrderMapPage> {
  @override
  void initState() {
    orderStatus = false;
    checkStatus();
    super.initState();
  }

  Future<void> checkStatus() async {
    ActivitiesNotifier activity =
        Provider.of<ActivitiesNotifier>(context, listen: false);
    UserNotifier user = Provider.of<UserNotifier>(context, listen: false);
    activity.reloadActivityModel(user.userModel.uid);
    if (activity.currentActivity.orderStatus == 'จัดส่งเรียบร้อยแล้ว') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => bottomBar()));
    }
    Future.delayed(Duration(seconds: 2), () {
      checkStatus();
      // print('check');
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);
    StoreNotifier store = Provider.of<StoreNotifier>(context);

    final orderDetailHeight = MediaQuery.of(context).size.height / 3;
    final mapHeight = MediaQuery.of(context).size.height - (orderDetailHeight);

    final routeColor = CollectionsColors.navy;
    final routeWidth = 5;
    final storeName = "จุดเริ่มต้น";
    final customerName = "ฉัน";
    final driverName = "ร้านค้า";
    final storeIcon = "assets/images/restaurant-marker-icon.png";
    final customerIcon = "assets/images/house-marker-icon.png";
    final driverIcon = "assets/images/driver-marker-icon.png";

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
                child: GoogleMapsWidget(
                  apiKey: GOOGLE_MAPS_API_KEY,
                  sourceLatLng: LatLng(
                    store.currentStore.realtimeLocation.latitude,
                    store.currentStore.realtimeLocation.longitude,
                  ),
                  destinationLatLng: LatLng(
                    activity.currentActivity.geoPoint.latitude,
                    activity.currentActivity.geoPoint.longitude,
                  ),
                  routeWidth: routeWidth,
                  routeColor: routeColor,
                  sourceMarkerIconInfo: MarkerIconInfo(
                    assetPath: storeIcon,
                    assetMarkerSize: Size.square(125),
                  ),
                  destinationMarkerIconInfo: MarkerIconInfo(
                    assetPath: customerIcon,
                  ),
                  driverMarkerIconInfo: MarkerIconInfo(
                    assetPath: driverIcon,
                  ),
                  driverCoordinatesStream: Stream.periodic(
                    Duration(milliseconds: 500),
                    (i) {
                      return LatLng(
                        store.currentStore.realtimeLocation.latitude,
                        store.currentStore.realtimeLocation.longitude,
                      );
                    },
                  ),
                  sourceName: storeName,
                  destinationName: customerName,
                  driverName: driverName,
                  totalTimeCallback: (time) => print(time),
                  totalDistanceCallback: (distance) => print(distance),
                ),
              ),
              information(
                orderDetailHeight,
                mapHeight,
                activity.currentActivity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget information(
      double orderDetailHeight, double mapHeight, Activity activity) {
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
                    activity.orderStatus,
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
                                  style:
                                      FontCollection.underlineButtonTextStyle,
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
