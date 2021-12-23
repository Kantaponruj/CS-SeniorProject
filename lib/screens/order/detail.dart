import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/widgets/icontext_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CollectionsColors.grey,
      resizeToAvoidBottomInset: true,
      appBar: ShopRoundedAppBar(
        appBarTitle: activity.currentActivity.storeName,
        automaticallyImplyLeading: true,
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
                headerText: 'เวลานัดหมาย',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: BuildIconText(
                          icon: Icons.calendar_today,
                          text: activity.currentActivity.dateOrdered != null
                              ? activity.currentActivity.dateOrdered
                              : DateFormat('d MMMM y').format(DateTime.now()),
                        ),
                      ),
                      BuildIconText(
                        icon: Icons.access_time,
                        // text:
                        // activity.startWaitingTime == null
                        //     ? 'ตอนนี้'
                        //     : activity.startWaitingTime.toString(),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                activity.currentActivity.startWaitingTime == null
                                    ? 'ตอนนี้'
                                    : activity.currentActivity.startWaitingTime
                                        ,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            activity.currentActivity.endWaitingTime == null
                                ? SizedBox.shrink()
                                : Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'จนถึง',
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                            activity.currentActivity.endWaitingTime == null
                                ? SizedBox.shrink()
                                : Container(
                                    child: activity.endWaitingTime == null
                                        ? Text(
                                            'กรุณากรอกเวลา',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    CollectionsColors.orange),
                                          )
                                        : Text(
                                            activity.endWaitingTime.toString() +
                                                '  น.',
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
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
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
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
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
}
