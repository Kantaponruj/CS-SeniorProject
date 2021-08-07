import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  const Address({Key key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'ที่อยู่ของคุณ',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
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
