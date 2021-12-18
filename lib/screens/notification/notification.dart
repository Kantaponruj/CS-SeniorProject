import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/screens/notification/notification_detail.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'Notification',
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              buildCard(
                'ไอศกรีมไผ่ทองโปรสุดพิเศษ',
                'เพียงซื้อไอศกรีมร้านไผ่ทอง 8-10 ก.ย. 64',
                '12.59',
              ),
              buildCard(
                'ใกล้ถึงเวลานัด !',
                'อีก 10 นาทีจะถึงเวลานัดของคุณกับร้านโตเกียวหน้า ม.',
                '12.42',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title, String subTitle, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationDetail())
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: ListTile(
            leading: Container(
              height: 80,
              width: 80,
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: CollectionsColors.yellow,
                foregroundImage: AssetImage('assets/images/default-photo.png'),
                radius: 80.0,
                child: Text(
                  '1',
                  style: FontCollection.descriptionTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            title: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: FontCollection.bodyBoldTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: AutoSizeText(
                    subTitle,
                    style: FontCollection.smallBodyTextStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  // alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
