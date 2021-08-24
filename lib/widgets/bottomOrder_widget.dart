import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class BottomOrder extends StatefulWidget {
  final Widget child;
  final VoidCallback onClicked;
  final String price;

  BottomOrder(
      {Key key, this.child, @required this.onClicked, @required this.price})
      : super(key: key);

  @override
  _BottomOrderState createState() => _BottomOrderState();
}

class _BottomOrderState extends State<BottomOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: CollectionsColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: widget.child,
          ),
          Container(
            child: StadiumConfirmButtonWidget(
                text: 'เพิ่มในตะกร้า',
                price: widget.price + ' บาท',
                onClicked: widget.onClicked),
          ),
        ],
      ),
    );
  }
}

class BottomOrderDetail extends StatefulWidget {
  final Widget child;
  final VoidCallback onClicked;

  BottomOrderDetail({Key key, this.child, @required this.onClicked})
      : super(key: key);

  @override
  _BottomOrderDetailState createState() => _BottomOrderDetailState();
}

class _BottomOrderDetailState extends State<BottomOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: CollectionsColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: widget.child,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ราคาสุทธิ',
                  style: FontCollection.topicBoldTextStyle,
                ),
                Text(
                  '80 บาท',
                  style: FontCollection.topicBoldTextStyle,
                ),
              ],
            ),
          ),
          Container(
            child: StadiumButtonWidget(
                text: 'ยืนยันการสั่งซื้อ', onClicked: widget.onClicked),
          ),
        ],
      ),
    );
  }
}
