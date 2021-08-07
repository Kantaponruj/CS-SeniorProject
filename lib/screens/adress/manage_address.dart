import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/screens/adress/selectAddress.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({Key key}) : super(key: key);

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'เลือกที่อยู่',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              StadiumButtonWidget(
                text: 'เลือกบนแผนที่',
                onClicked: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  SelectAddress(),));
                },
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'ที่อยู่ของคุณ',
                          style: FontCollection.topicTextStyle,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'บ้าน',
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: AutoSizeText(
                          '55/176 พฤกษาวิลเลจ 2 ถ.รังสิต ต.ลำผักกูด อ.ธัญบุรี จ.ปทุมธานี',
                          style: FontCollection.bodyTextStyle,
                          maxLines: 2,
                        ),
                      ),
                      Divider(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: AutoSizeText(
                          'คอนโด',
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: AutoSizeText(
                          '218 ไลบราลี่คอนโด ถนนประชาอุทิศ แขวงบางมด เขตทุ่งครุ กรุงเทพมหานคร',
                          style: FontCollection.bodyTextStyle,
                          maxLines: 2,
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              StadiumButtonWidget(
                text: 'เพิ่มที่อยู่ใหม่',
                onClicked: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
