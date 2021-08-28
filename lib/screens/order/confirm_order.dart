import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:cs_senior_project/screens/order/orderDetail.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:cs_senior_project/widgets/maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({Key key}) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final orderDetailHeight = MediaQuery.of(context).size.height / 2.7;
    final mapHeight = MediaQuery.of(context).size.height - (orderDetailHeight);

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
                child: MapWidget(mapController: _mapController),
              ),
              information(orderDetailHeight, mapHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget information(double orderDetailHeight, double mapHeight) {
    return Container(
      height: orderDetailHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: mapHeight - 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      radius: 60,
                      child: Image.asset(
                        "assets/images/shop_test.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'โตเกียวหน้าม.',
                            style: FontCollection.bodyTextStyle,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ของหวาน',
                            style:
                            FontCollection.descriptionTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          orderFinish = true;
                          orderedMenu = false;
                        });
                        Navigator.of(context).pushNamed('/orderDetail');
                      },
                      child: Text(
                        'รายละเอียด',
                        style: FontCollection.bodyTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      'เวลาสั่งซื้อ',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      '21 เมษายน 2564 ',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      '12.30 น.',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      'สถานที่',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: AutoSizeText(
                      '2 Library houze ถนนประชาอุทิศ ทุ่งครุ ราษฎรบูรณะ กทม',
                      style: FontCollection.bodyTextStyle,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          StadiumButtonWidget(
            text: 'โทร',
            onClicked: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
    );
  }

}
