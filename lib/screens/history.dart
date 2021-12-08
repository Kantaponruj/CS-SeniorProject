import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/order/confirm_order_map.dart';
import 'package:cs_senior_project/screens/order/confirm_order_detail.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    ActivitiesNotifier activitiesNotifier =
        Provider.of<ActivitiesNotifier>(context, listen: false);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getHistoryOrder(activitiesNotifier, userNotifier.userModel.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activities = Provider.of<ActivitiesNotifier>(context);
    StoreNotifier stores = Provider.of<StoreNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'ประวัติการสั่งซื้อ',
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                BuildCard(
                  headerText: 'การสั่งซื้อปัจจุบัน',
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: activities.activitiesList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final activity = activities.activitiesList[index];
                          return activity.orderStatus == 'กำลังดำเนินการ' ||
                                  activity.orderStatus == 'ยืนยันคำสั่งซื้อ' ||
                                  activity.orderStatus == 'ยืนยันการจัดส่ง'
                              ? ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            CollectionsColors.orange,
                                        foregroundColor: Colors.white,
                                        radius: 50.0,
                                        child: Icon(
                                          activity.typeOrder == 'pick up'
                                              ? Icons.local_shipping
                                              : Icons.directions_walk,
                                        )),
                                  ),
                                  title: buildText(
                                    activity.orderStatus.toString(),
                                    activity.dateOrdered,
                                    '${activity.netPrice} บาท',
                                    buildListTitle(
                                      Icons.fastfood_outlined,
                                      activity.storeName,
                                    ),
                                    buildListTitle(
                                      Icons.location_on,
                                      activity.addressName.isNotEmpty
                                          ? activity.addressName
                                          : '${activity.address.characters.getRange(0, 10)}...',
                                    ),
                                    activity.orderStatus.toString() !=
                                        'ยกเลิกคำสั่งซื้อ',
                                  ),
                                  onTap: () {
                                    stores.storeList.forEach((store) {
                                      if (activity.storeId == store.storeId) {
                                        stores.currentStore = store;
                                      }
                                    });
                                    activities.currentActivity = activity;

                                    if (activity.orderStatus ==
                                        'ยืนยันการจัดส่ง') {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmedOrderMapPage(),
                                        ),
                                      );
                                    } else {
                                      activities.orderMenuList.clear();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmOrderDetail(),
                                        ),
                                      );
                                    }
                                  },
                                )
                              : Container();
                        },
                      )),
                  canEdit: false,
                ),
                BuildCard(
                  headerText: 'ประวัติการสั่งซื้อ',
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: activities.activitiesList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final activity = activities.activitiesList[index];
                          return activity.orderStatus == 'จัดส่งเรียบร้อยแล้ว'
                              ? ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                      backgroundColor: CollectionsColors.orange,
                                      foregroundColor: Colors.white,
                                      radius: 50.0,
                                      child: Icon(
                                        activity.typeOrder == 'pick up'
                                            ? Icons.local_shipping
                                            : Icons.directions_walk,
                                      ),
                                    ),
                                  ),
                                  title: buildText(
                                    activity.orderStatus.toString(),
                                    activity.dateOrdered,
                                    '${activity.netPrice} บาท',
                                    buildListTitle(
                                      Icons.fastfood_outlined,
                                      activity.storeName,
                                    ),
                                    buildListTitle(
                                      Icons.location_on,
                                      activity.addressName.isNotEmpty
                                          ? activity.addressName
                                          : '${activity.address.characters.getRange(0, 10)}...',
                                    ),
                                    activity.orderStatus.toString() !=
                                        'ยกเลิกคำสั่งซื้อ',
                                  ),
                                  onTap: () {
                                    activities.currentActivity = activity;

                                    if (activity.orderStatus ==
                                        'จัดส่งเรียบร้อยแล้ว') {
                                      activities.orderMenuList.clear();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmOrderDetail(),
                                        ),
                                      );
                                    }
                                  },
                                )
                              : Container();
                        },
                      )),
                  canEdit: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTitle(IconData icons, String text) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Icon(
            icons,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: AutoSizeText(
              text,
              style: FontCollection.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildText(
    String orderStatus,
    String date,
    String price,
    Widget childStore,
    Widget childAddress,
    bool check,
  ) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    orderStatus,
                    maxLines: 1,
                    style: (check)
                        ? FontCollection.bodyTextStyle
                        : TextStyle(
                            fontSize: 16,
                            color: CollectionsColors.red,
                          ),
                  ),
                ),
                Container(
                  // alignment: Alignment.topRight,
                  child: Text(
                    date,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(child: childStore),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                childAddress,
                Container(
                  // alignment: Alignment.bottomRight,
                  child: AutoSizeText(
                    price,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
