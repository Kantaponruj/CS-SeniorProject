import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/address/manage_address.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({Key key, this.storeId}) : super(key: key);

  final String storeId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  DateTime now = new DateTime.now();
  DateFormat dateFormat;
  DateFormat timeFormat;

  Activities _activities = Activities();
  int netPrice = 0;
  List indexMenu = [];
  // int lengthIndexMenu;

  TextEditingController otherMessageController = new TextEditingController();

  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);

    for (int i = 0; i < orderNotifier.orderList.length; i++) {
      if (orderNotifier.orderList[i].storeId == widget.storeId) {
        indexMenu.add(i);
        netPrice += int.parse(orderNotifier.orderList[i].totalPrice);
      }
    }

    // lengthIndexMenu = indexMenu.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);
    ActivitiesNotifier activitiesNotifier =
        Provider.of<ActivitiesNotifier>(context);

    dateFormat = DateFormat('d MMMM y');
    timeFormat = DateFormat.Hm('cs');

    _activities.customerName =
        userNotifier.userModel.selectedAddress['residentName'] == ""
            ? userNotifier.userModel.displayName
            : userNotifier.userModel.selectedAddress['residentName'];
    _activities.phone = userNotifier.userModel.selectedAddress['phone'] == ""
        ? userNotifier.userModel.phone
        : userNotifier.userModel.selectedAddress['phone'];
    _activities.address =
        userNotifier.userModel.selectedAddress['address'] == ""
            ? locationNotifier.currentAddress
            : userNotifier.userModel.selectedAddress['address'];
    _activities.addressDetail =
        userNotifier.userModel.selectedAddress['addressDetail'];
    _activities.geoPoint =
        userNotifier.userModel.selectedAddress['geoPoint'] == GeoPoint(0, 0)
            ? GeoPoint(locationNotifier.currentPosition.latitude,
                locationNotifier.currentPosition.longitude)
            : userNotifier.userModel.selectedAddress['geoPoint'];
    _activities.message = otherMessageController.text.trim() ?? "";
    _activities.dateOrdered = dateFormat.format(now);
    _activities.timeOrdered = timeFormat.format(now);
    _activities.netPrice = netPrice.toString();
    _activities.storeId = storeNotifier.currentStore.storeId;
    _activities.storeName = storeNotifier.currentStore.storeName;
    _activities.storeImage = storeNotifier.currentStore.image;
    _activities.kindOfFood = storeNotifier.currentStore.kindOfFood;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: CollectionsColors.grey,
        appBar: ShopRoundedAppBar(
          appBarTitle: storeNotifier.currentStore.storeName,
          onClicked2: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShopDetail(),
            ));
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildCard(
                  headerText: 'ข้อมูลผู้สั่งซื้อ',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundColor: CollectionsColors.yellow,
                            radius: 35.0,
                            child: Text(
                              _activities.customerName[0],
                              style: FontCollection.descriptionTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 30),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    _activities.customerName,
                                    style: FontCollection.bodyTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    _activities.phone,
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                  child: Text(
                                    _activities.address ?? 'โปรดระบุที่อยู่',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  canEdit: true,
                  onClicked: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ManageAddress(uid: userNotifier.userModel.uid),
                      ),
                    );
                  },
                ),
                // BuildCard(
                //   headerText: 'เวลานัดหมาย',
                //   child: Container(
                //     padding: EdgeInsets.all(20),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Container(
                //           child: Text(
                //             'วันที่',
                //             style: FontCollection.bodyTextStyle,
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //         Container(
                //           child: Text(
                //             '21 เมษายน 2564',
                //             style: FontCollection.bodyTextStyle,
                //             textAlign: TextAlign.right,
                //           ),
                //         ),
                //         Container(
                //           child: Text(
                //             'เวลา',
                //             style: FontCollection.bodyTextStyle,
                //             textAlign: TextAlign.right,
                //           ),
                //         ),
                //         Container(
                //           child: Text(
                //             '12.30 น.',
                //             style: FontCollection.bodyTextStyle,
                //             textAlign: TextAlign.right,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   canEdit: false,
                // ),
                BuildCard(
                  headerText: 'สรุปการสั่งซื้อ',
                  editText: 'เพิ่มเมนู',
                  onClicked: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: indexMenu.length,
                            itemBuilder: (context, index) {
                              return listOrder(
                                orderNotifier.orderList[indexMenu[index]],
                                indexMenu[index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                          ),
                        ),
                        orderFinish
                            ? Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        'ราคาสุทธิ',
                                        style: FontCollection.bodyTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          netPrice.toString(),
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'บาท',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  canEdit: true,
                ),
                orderFinish
                    ? Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'ยกเลิกคำสั่งซื้อ',
                            style: FontCollection.underlineButtonTextStyle,
                          ),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
        bottomNavigationBar: orderFinish
            ? SizedBox.shrink()
            : BottomOrderDetail(
                onClicked: () {
                  saveDeliveryOrder(
                    storeNotifier.currentStore.storeId,
                    _activities,
                  );

                  saveToHistory(
                    userNotifier.userModel.uid,
                    _activities,
                  );

                  for (int i = 0; i < orderNotifier.orderList.length; i++) {
                    saveOrder(
                      storeNotifier.currentStore.storeId,
                      orderNotifier.orderList[i],
                    );

                    saveOrderToHistory(
                      userNotifier.userModel.uid,
                      orderNotifier.orderList[i],
                    );
                  }
                  activitiesNotifier.currentActivity = _activities;
                  Navigator.of(context).pushReplacementNamed('/confirmOrder');
                  // orderNotifier.orderList.clear();
                  // indexMenu.clear();

                  // for (int i in indexMenu) {
                  //   indexMenu.remove((data) => data == indexMenu[i]);
                  //   orderNotifier
                  //       .removeOrder(orderNotifier.orderList[indexMenu[i]]);
                  // }
                  // indexMenu.clear();
                  // print(orderNotifier.orderList.map((data) => data.menuName));
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'ข้อความเพิ่มเติม',
                        style: FontCollection.bodyTextStyle,
                      ),
                    ),
                    TextFormField(
                      controller: otherMessageController,
                      decoration: InputDecoration(
                        // errorText: 'Error message',
                        hintText: 'ใส่ข้อความตรงนี้',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                      ),
                    ),
                  ],
                ),
                netPrice: netPrice.toString(),
              ),
      ),
    );
  }

  Widget listOrder(OrderModel order, int index) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    // OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    order.amount.toString(),
                    style: FontCollection.bodyBoldTextStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  order.menuName,
                  style: FontCollection.bodyTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    order.totalPrice,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'บาท',
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ),
            ],
          ),
          order.topping.isEmpty
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 10,
                            child: Row(children: [
                              Text(
                                order.topping.join(', '),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: smallestSize,
                                  color: Colors.black54,
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                      order.other.isEmpty
                          ? SizedBox.shrink()
                          : Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                order.other,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                    ],
                  ),
                ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: EditButton(
                        editText: 'แก้ไข',
                        onClicked: () {
                          for (int i = 0;
                              i < storeNotifier.menuList.length;
                              i++) {
                            if (order.menuName ==
                                storeNotifier.menuList[i].name) {
                              storeNotifier.currentMenu =
                                  storeNotifier.menuList[i];
                              break;
                            }
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuDetail(
                                storeId: storeNotifier.currentStore.storeId,
                                menuId: storeNotifier.currentMenu.menuId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          // setState(() {
                          //   orderNotifier.removeOrder(order);
                          //   indexMenu.remove((data) => data == index);
                          //   lengthIndexMenu = indexMenu.length;
                          // });

                          // print(indexMenu.length);
                          // print(orderNotifier.orderList
                          //     .map((data) => data.menuName));
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
