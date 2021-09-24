import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'ประวัติการสั่งซื้อ',
        ),
        // AppBar(
        //   title: Text('Test'),
        //   centerTitle: true,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        // ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              BuildCard(
                  headerText: 'การสั่งซื้อปัจจุบัน',
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: Container(
                        height: 80,
                        width: 80,
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundColor: CollectionsColors.yellow,
                          radius: 100.0,
                          child: Text(
                            '1',
                            style: FontCollection.descriptionTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      title: Text(
                        'กำลังดำเนินการ',
                        style: FontCollection.bodyTextStyle,
                      ),
                      subtitle: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            buildListTitle(
                                Icons.fastfood_outlined, 'ร้านโตเกียวเจ๊หยี'),
                            buildListTitle(Icons.location_on, 'บ้าน'),
                          ],
                        ),
                      ),
                      trailing: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // alignment: Alignment.topRight,
                              child: Text(
                                '15 เม.ย. 2021',
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            Container(
                              // alignment: Alignment.bottomRight,
                              child: Text(
                                '95 บาท',
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  canEdit: false),
              BuildCard(
                headerText: 'ประวัติการสั่งซื้อ',
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        backgroundColor: CollectionsColors.yellow,
                        radius: 100.0,
                        child: Text(
                          '1',
                          style: FontCollection.descriptionTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    title: Text(
                      'กำลังดำเนินการ',
                      style: FontCollection.bodyTextStyle,
                    ),
                    subtitle: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          buildListTitle(
                              Icons.fastfood_outlined, 'ร้านโตเกียวเจ๊หยี'),
                          buildListTitle(Icons.location_on, 'บ้าน'),
                        ],
                      ),
                    ),
                    trailing: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // alignment: Alignment.topRight,
                            child: Text(
                              '15 เม.ย. 2021',
                              style: FontCollection.bodyTextStyle,
                            ),
                          ),
                          Container(
                            // alignment: Alignment.bottomRight,
                            child: Text(
                              '95 บาท',
                              style: FontCollection.bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget buildListTitle(IconData icons, String text) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Icon(
            icons,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: FontCollection.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
