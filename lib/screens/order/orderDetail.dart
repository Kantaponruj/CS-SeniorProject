import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/screens/adress/address.dart';
import 'package:cs_senior_project/screens/adress/manage_address.dart';
import 'package:cs_senior_project/screens/adress/selectAddress.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  // OrderDetailPage(this.meetingId);
  //
  // final String meetingId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (counter) => 'Item: $counter');

    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: CollectionsColors.grey,
        appBar: RoundedAppBar(
          appBarTitle: 'ข้อมูลการสั่งซื้ออาหาร',
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0,10,0,20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OrderCard(
                  headerText: 'ข้อมูลผู้สั่งซื้อ',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundColor: CollectionsColors.yellow,
                            radius: 35.0,
                            child: Text(
                              '1',
                              style: FontCollection.descriptionTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 30),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Jane Cooper',
                                    style: FontCollection.bodyTextStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '0862584569',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                  child: Text(
                                    '2 Library houze ถนนประชาอุทิศ \nทุ่งครุ ราษฎรบูรณะ กทม',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  canEdit: true,
                  onClicked: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageAddress(),
                        ));
                  },
                ),
                OrderCard(
                  headerText: 'เวลานัดหมาย',
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            'วันที่',
                            style: FontCollection.bodyTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          child: Text(
                            '21 เมษายน 2564',
                            style: FontCollection.bodyTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          child: Text(
                            'เวลา',
                            style: FontCollection.bodyTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          child: Text(
                            '12.30 น.',
                            style: FontCollection.bodyTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  canEdit: false,
                ),
                OrderCard(
                  headerText: 'สรุปการสั่งซื้อ',
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return listOrder(index);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  'ราคาสุทธิ',
                                  style: FontCollection.bodyTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '6',
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
        bottomNavigationBar: BottomOrderDetail(
          onClicked: () {

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
              TextFormField(
                decoration: InputDecoration(
                  // errorText: 'Error message',
                  hintText: 'ใส่ข้อความตรงนี้',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // suffixIcon: Icon(
                  //   Icons.error,
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listOrder(int index) => Container(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '2',
                  style: FontCollection.bodyTextStyle,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                'โตเกียวไส้เค็ม',
                style: FontCollection.bodyTextStyle,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '40',
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
      );
}
