import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/order/orderDetail.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDetail extends StatefulWidget {
  static const routeName = '/history';

  @override
  _MenuDetailState createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    final double imgHeight = MediaQuery.of(context).size.height / 4;

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: imgHeight,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          child: Image.network(
                            storeNotifier.currentMenu.image != null
                                ? storeNotifier.currentMenu.image
                                : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                          // Image.asset(
                          //   'assets/images/shop_test.jpg',
                          //   fit: BoxFit.cover,
                          //   width: double.infinity,
                          //   height: double.infinity,
                          // ),
                          ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, imgHeight - 30, 20, 30),
                        child: Column(
                          children: [
                            menuDetailCard(storeNotifier),
                            moreCard(),
                            //end
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // SearchWidget(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomOrder(
          onClicked: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(),
                ));
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

  Widget menuDetailCard(StoreNotifier storeNotifier) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: CollectionsColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    storeNotifier.currentMenu.name,
                    style: FontCollection.topicTextStyle,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              storeNotifier.currentMenu.price,
                              style: FontCollection.topicTextStyle,
                            )),
                        Text(
                          'ราคาเริ่มต้น',
                          style: FontCollection.smallBodyTextStyle,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  storeNotifier.currentMenu.description,
                  style: FontCollection.bodyTextStyle,
                )),
          ],
        ),
      ),
    );
  }

  Widget moreCard() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      'เพิ่มเติม',
                      style: FontCollection.bodyBoldTextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'เลือกได้สูงสุด 2 อย่าง',
                        style: FontCollection.descriptionTextStyle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('test 1'),
                    Text('test 2'),
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
