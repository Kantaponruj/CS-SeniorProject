import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

class ConfirmOrderDetail extends StatefulWidget {
  ConfirmOrderDetail({Key key, this.fromHistory = false}) : super(key: key);

  final bool fromHistory;

  @override
  _ConfirmOrderDetailState createState() => _ConfirmOrderDetailState();
}

class _ConfirmOrderDetailState extends State<ConfirmOrderDetail> {
  int totalPrice = 0;

  TextEditingController otherMessageController = new TextEditingController();

  @override
  void initState() {
    UserNotifier user = Provider.of<UserNotifier>(context, listen: false);
    ActivitiesNotifier activity =
        Provider.of<ActivitiesNotifier>(context, listen: false);
    getOrderMenu(
        activity, user.userModel.uid, activity.currentActivity.orderId);
    user.reloadUserModel();
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
    if (activity.currentActivity.orderStatus == 'ยืนยันการจัดส่ง') {
      Navigator.of(context).pushReplacementNamed('/confirmOrderMap');
    }
    Future.delayed(Duration(seconds: 2), () {
      checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CollectionsColors.grey,
      resizeToAvoidBottomInset: true,
      appBar: ShopRoundedAppBar(
        appBarTitle: activity.currentActivity.storeName,
        automaticallyImplyLeading: widget.fromHistory ? true : false,
        leading: widget.fromHistory
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => bottomBar()));
                },
              ),
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
                  activity.currentActivity.customerName,
                  activity.currentActivity.phone,
                  activity.currentActivity.address,
                ),
              ),
              BuildCard(
                headerText: 'สรุปการสั่งซื้อ',
                onClicked: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: activity.orderMenuList.length,
                          itemBuilder: (context, index) {
                            return listOrder(activity.orderMenuList[index]);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: AutoSizeText('ค่าอาหารทั้งหมด'),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        AutoSizeText(
                                            activity.currentActivity.subTotal),
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child:
                                              AutoSizeText('บาท', maxLines: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: AutoSizeText('ค่าส่ง'),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        AutoSizeText(activity
                                            .currentActivity.shippingFee),
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child:
                                              AutoSizeText('บาท', maxLines: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          activity.currentActivity.netPrice,
                                          style:
                                              FontCollection.bodyBoldTextStyle,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: AutoSizeText(
                                            'บาท',
                                            maxLines: 1,
                                            style: FontCollection
                                                .bodyBoldTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                canEdit: false,
              ),
              BuildCard(
                headerText: 'ข้อความเพิ่มเติม',
                onClicked: () {},
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    activity.currentActivity.message,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
                canEdit: false,
              ),
              (activity.currentActivity.orderStatus == 'จัดส่งเรียบร้อยแล้ว')
                  ? SizedBox.shrink()
                  : Container(
                      margin: EdgeInsets.only(top: 20),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return cancelOrder(
                                    activity.currentActivity.phoneStore);
                              });
                        },
                        child: Text(
                          'ยกเลิกคำสั่งซื้อ',
                          style: FontCollection.underlineButtonTextStyle,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listOrder(OrderModel order) {
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
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget customerDeliCard(
    String name,
    String phoneNumber,
    String address,
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
            Container(
              child: Row(
                children: [
                  buildIconText(Icons.access_time, time),
                  Container(
                    child: Text(
                      'จนถึง',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                  Container(
                    child: Text(
                      'จนถึง',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ],
              ),
            ),
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
            mainAxisSize: MainAxisSize.min,
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
