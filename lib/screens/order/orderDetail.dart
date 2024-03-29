import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/component/textformfield.dart';
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
import 'package:cs_senior_project/widgets/icontext_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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
  List<OrderModel> orderList = [];
  TextEditingController otherMessageController = new TextEditingController();

  @override
  void initState() {
    UserNotifier user = Provider.of<UserNotifier>(context, listen: false);
    OrderNotifier order = Provider.of<OrderNotifier>(context, listen: false);
    user.reloadUserModel();
    orderList.clear();
    order.orderList.forEach((order) {
      if (order.storeId == widget.storeId) {
        orderList.add(order);
      }
    });
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
    _activities.phoneStore = store.currentStore.phone;

    String startTime = activity.startWaitingTime == null
        ? 'ตอนนี้'
        : activity.startWaitingTime
        .toString() +
        '  น.';
    String endTime = activity.endWaitingTime == null
        ?
    'กรุณากรอกเวลา' :
    activity.endWaitingTime.toString() +
        '  น.'
    ;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CollectionsColors.grey,
      resizeToAvoidBottomInset: true,
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
                        builder: (context) =>
                            ManageAddress(
                              uid: user.userModel.uid,
                              storePoint: LatLng(
                                store.currentStore.realtimeLocation.latitude,
                                store.currentStore.realtimeLocation.longitude,
                              ),
                              isDelivery: store.currentStore.isDelivery,
                              shippingfee: int.parse(
                                  store.currentStore.shippingfee
                                      .substring(0,
                                      store.currentStore.shippingfee.length -
                                          2)),
                            ),
                      ),
                    );
                  },
                ),
              ),
              _activities.typeOrder == 'pick up'
                  ? SizedBox.shrink()
                  : BuildCard(
                headerText: 'เวลานัดหมาย',
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: BuildIconText(
                          icon: Icons.calendar_today,
                          text: activity.dateOrdered != null
                              ? activity.dateOrdered
                              : DateFormat('d MMMM y')
                              .format(DateTime.now()),
                        ),
                      ),
                      BuildIconText(
                        icon: Icons.access_time,
                        child: AutoSizeText(
                          startTime + ' จนถึง ' + endTime,
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                canEdit: false,
              ),
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
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return listOrder(orderList[index], index);
                          },
                          separatorBuilder: (context, index) =>
                              Divider(
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
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
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
                                          child: AutoSizeText(
                                              'บาท', maxLines: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
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
                                          style: FontCollection
                                              .bodyBoldTextStyle,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                canEdit: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: orderFinish
          ? SizedBox.shrink()
          : BottomOrderDetail(
        onClicked: () {
          String typeOrder;
          if (_activities.endWaitingTime != null) {
            if (_activities.startWaitingTime != 'ตอนนี้' &&
                _activities.endWaitingTime != null) {
              typeOrder = 'meeting-orders';
            } else {
              typeOrder = 'delivery-orders';
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

            order.orderList.removeWhere(
                    (order) => order.storeId == store.currentStore.storeId);

            location.setCameraPositionMap(location.initialPosition);
          } else {
            if (store.currentStore.isDelivery) {
              Fluttertoast.showToast(
                msg: "โปรดระบุช่วงเวลาที่สามารถรอได้",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              typeOrder = 'pickup-orders';

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

              // activity.resetDateTimeOrdered();
              order.orderList.removeWhere(
                      (order) => order.storeId == store.currentStore.storeId);
              orderList.clear();
              location.setCameraPositionMap(location.initialPosition);
            }
          }
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
            BuildPlainTextField(
              textEditingController: otherMessageController,
              hintText: 'ใส่ข้อความตรงนี้',
            ),
          ],
        ),
        netPrice: order.netPrice.toString(),
      ),
    );
  }

  Widget listOrder(OrderModel order, int index) {
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
                  child: AutoSizeText(
                    order.amount.toString(),
                    style: FontCollection.bodyBoldTextStyle,
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: AutoSizeText(
                  order.menuName,
                  style: FontCollection.bodyTextStyle,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    order.totalPrice,
                    style: FontCollection.bodyTextStyle,
                    maxLines: 1,
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
            child: Row(
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
          ),
          order.other.isEmpty
              ? SizedBox.shrink()
              : Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Text(
                        order.other,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: smallestSize,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
                              builder: (context) =>
                                  MenuDetail(
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
                          orderList.removeAt(index);
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

  Widget customerDeliCard(String name,
      String phoneNumber,
      String address,
      VoidCallback onClickedContact,
      VoidCallback onClickedAddress,) {
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

  Widget customerPickCard(String name,
      String phoneNumber,
      String address,
      VoidCallback onClicked,) {
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

  Widget meetingTimeCard(String date,
      String time,) {
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

  Widget deliTimeCard(String date,
      String time,) {
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

  Widget editContactInfo(String name, String phone, LocationNotifier location) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
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
                initialValue: name,
                onChanged: (value) {
                  location.selectedAddress.residentName = value;
                },
                hintText: 'กรุณากรอกชื่อผู้ใช้',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: BuildTextField(
                labelText: 'เบอร์โทรศัพท์',
                initialValue: phone,
                onChanged: (value) {
                  location.selectedAddress.phone = value;
                },
                validator: (value) {
                  if (value.length < 10 || value[0] != '0') {
                    return 'โปรดระบุเบอร์โทรศัพท์ให้ถูกต้อง';
                  }

                  return null;
                },
                hintText: 'กรุณากรอกเบอร์โทรศัพท์',
                textInputType: TextInputType.phone,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 20),
              child: NoShapeButton(
                onClicked: () {
                  Navigator.pop(context);
                },
                text: 'บันทึก',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelOrder(String phone) {
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
                  'กรุณาติดต่อผู้ขายที่เบอร์ ' + phone,
                  style: FontCollection.bodyTextStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: StadiumButtonWidget(
                  text: 'โทรติดต่อผู้ขาย',
                  onClicked: () async {
                    String number = phone;
                    // launch('tel://$number');
                    await FlutterPhoneDirectCaller.callNumber(number);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
