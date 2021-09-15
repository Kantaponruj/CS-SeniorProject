import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/order/confirm_order.dart';
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
        // AppBar(
        //   title: Text('Test'),
        //   centerTitle: true,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        // ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                activities.currentActivity == null
                    ? Container()
                    : BuildCard(
                        headerText: 'การสั่งซื้อปัจจุบัน',
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ListTile(
                            leading: Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundColor: CollectionsColors.yellow,
                                radius: 100.0,
                                child: Text(
                                  '1',
                                  style: FontCollection.descriptionTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            title: Text(
                              'กำลังดำเนินการ',
                              style: FontCollection.bodyTextStyle,
                            ),
                            subtitle: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  buildListTitle(Icons.fastfood_outlined,
                                      activities.currentActivity.storeName),
                                  buildListTitle(Icons.location_on,
                                      activities.currentActivity.addressName),
                                ],
                              ),
                            ),
                            trailing: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // alignment: Alignment.topRight,
                                    child: Text(
                                      activities.currentActivity.dateOrdered,
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                                  Container(
                                    // alignment: Alignment.bottomRight,
                                    child: Text(
                                      activities.currentActivity.netPrice,
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              for (int i = 0;
                                  i < stores.storeList.length;
                                  i++) {
                                if (activities.currentActivity.storeId ==
                                    stores.storeList[i].storeId) {
                                  stores.currentStore = stores.storeList[i];
                                  break;
                                }
                              }

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ConfirmedOrderMapPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        canEdit: false,
                      ),
                BuildCard(
                  headerText: 'ประวัติการสั่งซื้อ',
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: activities.activitiesList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundColor: CollectionsColors.yellow,
                                radius: 100.0,
                                child: Text(
                                  activities
                                      .activitiesList[index].customerName[0],
                                  style: FontCollection.descriptionTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            title: Text(
                              'การสั่งซื้อสำเร็จ',
                              style: FontCollection.bodyTextStyle,
                            ),
                            subtitle: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  buildListTitle(
                                    Icons.fastfood_outlined,
                                    activities.activitiesList[index].storeName,
                                  ),
                                  buildListTitle(
                                    Icons.location_on,
                                    activities
                                        .activitiesList[index].addressName,
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // alignment: Alignment.topRight,
                                    child: Text(
                                      activities
                                          .activitiesList[index].dateOrdered,
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                                  Container(
                                    // alignment: Alignment.bottomRight,
                                    child: Text(
                                      '${activities.activitiesList[index].netPrice} บาท',
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              activities.currentActivity =
                                  activities.activitiesList[index];

                              for (int i = 0;
                                  i < stores.storeList.length;
                                  i++) {
                                if (activities.activitiesList[index].storeId ==
                                    stores.storeList[i].storeId) {
                                  stores.currentStore = stores.storeList[i];
                                  break;
                                }
                              }

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ConfirmedOrderMapPage(),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
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
            child: Text(
              text,
              style: FontCollection.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
