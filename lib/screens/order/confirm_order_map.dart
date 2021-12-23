import 'dart:async';

import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/order/detail.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:cs_senior_project/widgets/map_confirmed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

class ConfirmedOrderMapPage extends StatefulWidget {
  const ConfirmedOrderMapPage({Key key}) : super(key: key);

  @override
  _ConfirmedOrderMapPageState createState() => _ConfirmedOrderMapPageState();
}

class _ConfirmedOrderMapPageState extends State<ConfirmedOrderMapPage> {
  bool orderStatus;

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
    activity.reloadActivityModel(
      user.userModel.uid,
      activity.currentActivity.orderId,
    );
    if (activity.currentActivity.orderStatus == 'จัดส่งเรียบร้อยแล้ว') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBar()));
    }
    Future.delayed(Duration(seconds: 2), () {
      checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);

    final orderDetailHeight = MediaQuery.of(context).size.height / 3;
    final mapHeight = MediaQuery.of(context).size.height - (orderDetailHeight);

    return Scaffold(
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
              child: MapConfirmedWidet(),
            ),
            Container(
              height: orderDetailHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(top: mapHeight - 20),
              child: SingleChildScrollView(
                child: information(orderDetailHeight, mapHeight, activity.currentActivity,
                    activity.arrivableTime),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget information(double orderDetailHeight, double mapHeight,
      Activity activity, String arrivableTime) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    arrivableTime != null
                        ? 'จะได้รับภายใน ${arrivableTime} นาที'
                        : '',
                    style: FontCollection.topicTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: activity.storeImage.isNotEmpty
                          ? NetworkImage(activity.storeImage)
                          : AssetImage('assets/images/default-photo.png'),
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailPage()));
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
                                activity.kindOfFood.join(', '),
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
          Container(
            padding: EdgeInsets.only(top: 10),
            child: StadiumButtonWidget(
              text: 'โทร',
              onClicked: () async {
                String number = activity.phoneStore;
                await FlutterPhoneDirectCaller.callNumber(number);
              },
            ),
          ),
        ],
      ),
    );
  }
}
