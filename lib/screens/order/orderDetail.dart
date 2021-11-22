import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/component/textformfiled.dart';
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
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
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
  DateFormat dateFormat = DateFormat('d MMMM y');
  DateFormat timeFormat = DateFormat.Hm('cs');

  Activity _activities = Activity();

  TextEditingController otherMessageController = new TextEditingController();

  @override
  void initState() {
    UserNotifier user = Provider.of<UserNotifier>(context, listen: false);
    user.reloadUserModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier user = Provider.of<UserNotifier>(context);
    StoreNotifier store = Provider.of<StoreNotifier>(context);
    OrderNotifier order = Provider.of<OrderNotifier>(context);
    LocationNotifier location = Provider.of<LocationNotifier>(context);
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);

    _activities.customerId = user.userModel.uid;
    _activities.customerName = location.selectedAddress.residentName == ''
        ? user.userModel.displayName
        : location.selectedAddress.residentName;
    _activities.phone = location.selectedAddress.phone == ''
        ? user.userModel.phone
        : location.selectedAddress.phone;
    _activities.address = location.selectedAddress.address == ''
        ? location.currentAddress
        : location.selectedAddress.address;
    _activities.addressName = location.selectedAddress.addressName;
    _activities.addressDetail = location.selectedAddress.addressDetail;
    _activities.geoPoint = location.selectedAddress.geoPoint == GeoPoint(0, 0)
        ? GeoPoint(location.currentPosition.latitude,
            location.currentPosition.longitude)
        : location.selectedAddress.geoPoint;
    _activities.message = otherMessageController.text.trim() ?? '';
    _activities.dateOrdered = activity.dateOrdered ?? dateFormat.format(now);
    _activities.timeOrdered = timeFormat.format(now);
    _activities.startWaitingTime = activity.startWaitingTime != null
        ? activity.startWaitingTime
        : 'ตอนนี้';
    _activities.endWaitingTime = activity.endWaitingTime;
    _activities.netPrice = order.netPrice.toString();
    _activities.storeId = store.currentStore.storeId;
    _activities.storeName = store.currentStore.storeName;
    _activities.storeImage = store.currentStore.image;
    _activities.kindOfFood = store.currentStore.kindOfFood;
    _activities.orderStatus = "กำลังดำเนินการ";
    _activities.amountOfMenu = order.orderList.length.toString();
    _activities.distance = order.distance;
    _activities.shippingFee = order.shippingFee;
    _activities.subTotal = order.totalFoodPrice.toString();
    _activities.typeOrder =
        store.currentStore.isDelivery ? 'delivery' : 'pick up';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CollectionsColors.grey,
      appBar: ShopRoundedAppBar(
        appBarTitle: store.currentStore.storeName,
        onClicked: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShopDetail(),
          ));
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 120, 20, 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(),
                child: customerDeliCard(
                  _activities.customerName,
                  _activities.phone,
                  _activities.address ?? 'โปรดระบุที่อยู่',
                  () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return editContactInfo(
                            _activities.customerName,
                            _activities.phone,
                            location,
                          );
                        });
                  },
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ManageAddress(
                          uid: user.userModel.uid,
                          storePoint: LatLng(
                            store.currentStore.realtimeLocation.latitude,
                            store.currentStore.realtimeLocation.longitude,
                          ),
                          isDelivery: store.currentStore.isDelivery,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // deliTimeCard(_activities.dateOrdered, _activities.timeOrdered),
              // meetingTimeCard('21 เมษายน 2564', '12.30 น.'),
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
                          itemCount: order.orderList.length,
                          itemBuilder: (context, index) {
                            return (order.orderList[index].storeId ==
                                    widget.storeId)
                                ? listOrder(order.orderList[index])
                                : Container();
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: AutoSizeText('ค่าอาหารทั้งหมด'),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      AutoSizeText(
                                          order.totalFoodPrice.toString()),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: AutoSizeText('บาท', maxLines: 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: AutoSizeText('ค่าส่ง'),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      AutoSizeText(order.shippingFee),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: AutoSizeText('บาท', maxLines: 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: AutoSizeText(
                                    'ราคาสุทธิ',
                                    style: FontCollection.bodyBoldTextStyle,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      AutoSizeText(
                                        order.netPrice.toString(),
                                        style: FontCollection.bodyBoldTextStyle,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: AutoSizeText(
                                          'บาท',
                                          maxLines: 1,
                                          style:
                                              FontCollection.bodyBoldTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                canEdit: true,
              ),
              // orderFinish ? SizedBox.shrink() : BuildTextFiled(textEditingController: textEditingController, hintText: hintText),
              orderFinish
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return cancelOrder();
                              });
                        },
                        child: Text(
                          'ยกเลิกคำสั่งซื้อ',
                          style: FontCollection.underlineButtonTextStyle,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: orderFinish
          ? SizedBox.shrink()
          : BottomOrderDetail(
              onClicked: () {
                String typeOrder;
                if (_activities.startWaitingTime != 'ตอนนี้' &&
                    _activities.endWaitingTime != null) {
                  typeOrder = 'meeting-orders';
                } else {
                  switch (store.currentStore.isDelivery) {
                    case true:
                      typeOrder = 'delivery-orders';
                      break;
                    default:
                      typeOrder = 'pickup-orders';
                  }
                }

                saveActivityToHistory(
                  user.userModel.uid,
                  store.currentStore.storeId,
                  _activities,
                  typeOrder,
                );

                for (int i = 0; i < order.orderList.length; i++) {
                  if ((order.orderList[i].storeId == widget.storeId)) {
                    saveEachOrderToHistory(
                      user.userModel.uid,
                      store.currentStore.storeId,
                      order.orderList[i],
                      typeOrder,
                    );
                  }
                }
                activity.currentActivity = _activities;
                Navigator.of(context)
                    .pushReplacementNamed('/confirmOrderDetail');

                activity.resetDateTimeOrdered();
                order.orderList.removeWhere(
                    (order) => order.storeId == store.currentStore.storeId);

                location.setCameraPositionMap(location.initialPosition);
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
                      hintText: 'ใส่ข้อความตรงนี้',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              netPrice: order.netPrice.toString(),
            ),
    );
  }

  Widget listOrder(OrderModel order) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

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
                          storeNotifier.menuList.forEach((menu) {
                            if (order.menuName == menu.name) {
                              storeNotifier.currentMenu = menu;
                            }
                          });

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
                          orderNotifier.removeOrder(order);
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

  Widget customerDeliCard(
    String name,
    String phoneNumber,
    String address,
    VoidCallback onClickedContact,
    VoidCallback onClickedAddress,
  ) {
    return BuildCard(
      headerText: 'ข้อมูลผู้สั่งซื้อ',
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 20, 20),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: CollectionsColors.navy,
                radius: 35.0,
                child: Icon(
                  Icons.person,
                  color: CollectionsColors.white,
                ),
              ),
              title: Text(
                name,
                style: FontCollection.bodyTextStyle,
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                phoneNumber,
                style: FontCollection.bodyTextStyle,
              ),
              trailing: Icon(
                Icons.edit,
              ),
              onTap: onClickedContact,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: CollectionsColors.navy,
                  radius: 35.0,
                  child: Icon(
                    Icons.location_on,
                    color: CollectionsColors.white,
                  ),
                ),
                title: AutoSizeText(
                  address,
                  style: FontCollection.bodyTextStyle,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  Icons.edit,
                ),
                onTap: onClickedAddress,
              ),
            ),
          ],
        ),
      ),
      canEdit: false,
    );
  }

  Widget customerPickCard(
    String name,
    String phoneNumber,
    String address,
    VoidCallback onClicked,
  ) {
    return BuildCard(
      headerText: 'ข้อมูลผู้สั่งซื้อ',
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 20, 20),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: CollectionsColors.navy,
            radius: 35.0,
            child: Icon(
              Icons.person,
              color: CollectionsColors.white,
            ),
          ),
          title: Text(
            name,
            style: FontCollection.bodyTextStyle,
            textAlign: TextAlign.left,
          ),
          subtitle: Text(
            phoneNumber,
            style: FontCollection.bodyTextStyle,
          ),
          trailing: Icon(
            Icons.edit,
          ),
          onTap: onClicked,
        ),
      ),
      canEdit: false,
    );
  }

  Widget meetingTimeCard(
    String date,
    String time,
  ) {
    return BuildCard(
      headerText: 'เวลานัดหมาย',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildIconText(Icons.calendar_today, date),
            buildIconText(Icons.access_time, time),
          ],
        ),
      ),
      canEdit: false,
    );
  }

  Widget deliTimeCard(
    String date,
    String time,
  ) {
    return BuildCard(
      headerText: 'เวลาจัดส่ง',
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 10, 60, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildIconText(Icons.calendar_today, date),
            buildIconText(Icons.access_time, time),
          ],
        ),
      ),
      canEdit: false,
    );
  }

  Widget buildIconText(IconData icon, String text) {
    return Container(
      child: Row(
        children: [
          Container(
            child: Icon(icon),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: FontCollection.bodyTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController controller;
  TextEditingController residentName = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();

  String text;

  Widget editContactInfo(String name, String phone, LocationNotifier location) {
    // residentName.text = name;
    // phoneNumber.text = phone;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'แก้ไขข้อมูลการติดต่อ',
                style: FontCollection.topicTextStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: BuildTextField(
                labelText: 'ชื่อผู้ใช้',
                textEditingController: residentName,
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                hintText: 'กรุณากรอกชื่อผู้ใช้',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: BuildTextField(
                labelText: 'เบอร์โทรศัพท์',
                textEditingController: phoneNumber,
                hintText: 'กรุณากรอกเบอร์โทรศัพท์',
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 20),
              child: NoShapeButton(
                onClicked: () {
                  // setState(() {
                  //   location.selectedAddress.residentName =
                  //       residentName.text.trim();
                  //   location.selectedAddress.phone = phoneNumber.text.trim();
                  //   Navigator.pop(context);
                  // });
                  print(text.trim());
                  print('name: ${residentName.text.trim()}');
                  print('phone: ${phoneNumber.text.trim()}');
                },
                text: 'บันทึก',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelOrder() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Container(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      content: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'ยกเลิกสินค้า',
                  style: FontCollection.topicTextStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'กรุณาติดต่อผู้ขายที่เบอร์ 08123456789',
                  style: FontCollection.bodyTextStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: StadiumButtonWidget(
                  text: 'โทรติดต่อผู้ขาย',
                  onClicked: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
