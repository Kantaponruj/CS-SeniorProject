import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({Key key, this.storeId}) : super(key: key);

  final String storeId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int netPrice = 0;
  String customerName, phone, address, addressDetail;
  GeoPoint geoPoint;

  TextEditingController otherMessageController = new TextEditingController();

  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);

    for (int i = 0; i < orderNotifier.orderList.length; i++) {
      netPrice += int.parse(orderNotifier.orderList[i].totalPrice);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    customerName = userNotifier.userModel.selectedAddress['residentName'] == ""
        ? userNotifier.userModel.displayName
        : userNotifier.userModel.selectedAddress['residentName'];
    phone = userNotifier.userModel.selectedAddress['phone'] == ""
        ? userNotifier.userModel.phone
        : userNotifier.userModel.selectedAddress['phone'];
    address = userNotifier.userModel.selectedAddress['address'] == ""
        ? locationNotifier.currentAddress
        : userNotifier.userModel.selectedAddress['address'];
    addressDetail = userNotifier.userModel.selectedAddress['addressDetail'];
    geoPoint =
        userNotifier.userModel.selectedAddress['geoPoint'] == GeoPoint(0, 0)
            ? GeoPoint(locationNotifier.currentPosition.latitude,
                locationNotifier.currentPosition.longitude)
            : userNotifier.userModel.selectedAddress['geoPoint'];

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
                              customerName[0],
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
                                    customerName,
                                    style: FontCollection.bodyTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    phone,
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                  child: Text(
                                    address ?? 'โปรดระบุที่อยู่',
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
                    Navigator.of(context).pushNamed('/manageAddress');
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
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: orderNotifier.orderList.length,
                            itemBuilder: (context, index) {
                              // final item = items[index];
                              return listOrder(orderNotifier.orderList[index]);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
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
                        ),
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
                    widget.storeId,
                    customerName,
                    phone,
                    address,
                    addressDetail,
                    geoPoint,
                    netPrice.toString(),
                    otherMessageController.text.trim() ?? "",
                  );

                  for (int i = 0; i < orderNotifier.orderList.length; i++) {
                    saveOrder(widget.storeId, orderNotifier.orderList[i]);
                  }

                  orderNotifier.orderList.clear();

                  Navigator.of(context).pushReplacementNamed('/confirmOrder');
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

  Widget listOrder(OrderModel order) => Container(
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
                      style: FontCollection.bodyTextStyle,
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
            Column(
              children: [
                Row(
                  children: order.topping
                      .map((topping) => Text(
                            '$topping ',
                            style: FontCollection.bodyTextStyle,
                          ))
                      .toList(),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    order.other,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
