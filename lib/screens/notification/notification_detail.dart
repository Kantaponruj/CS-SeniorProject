import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:flutter/material.dart';

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({Key key}) : super(key: key);

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RoundedAppBar(
        appBarTitle: "Notification Detail",
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 90),
          child: Column(
            children: [
              Image.asset(
                'assets/images/default-photo.png',
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "ไอศกรีมไผ่ทองโปรสุดพิเศษ ",
                          style: FontCollection.bodyBoldTextStyle,
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "เพียงซื้อไอศกรีมร้านไผ่ทอง 8-10 ก.ย. 64 ผ่านแอปพลิเคชั่น",
                          style: FontCollection.bodyTextStyle,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
