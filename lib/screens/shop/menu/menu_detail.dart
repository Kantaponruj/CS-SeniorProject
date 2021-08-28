import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/order/orderDetail.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shop_menu.dart';

class MenuDetail extends StatefulWidget {
  MenuDetail({Key key, this.storeId, this.menuId}) : super(key: key);
  final String storeId;
  final String menuId;

  static const routeName = '/history';

  @override
  _MenuDetailState createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getTopping(storeNotifier, widget.storeId, widget.menuId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    Store store;
    final double imgHeight = MediaQuery.of(context).size.height / 4;

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          child: Stack(
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
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, imgHeight - 30, 20, 30),
                  child: Column(
                    children: [
                      menuDetailCard(storeNotifier),
                      moreCard(storeNotifier),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // SearchWidget(),
        ),
        bottomNavigationBar: BottomOrder(
          price: storeNotifier.currentMenu.price,
          onClicked: () {
            setState(() {
              orderedMenu = true;
            });
            Navigator.of(context).pop();
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

  Widget moreCard(StoreNotifier storeNotifier) {
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
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: storeNotifier.toppingList.length,
                itemBuilder: (context, index) {
                  return listAddOn(storeNotifier, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkboxValue = false;

  Widget listAddOn(StoreNotifier storeNotifier, int index) {
    return ListTile(
      leading: checkbox(checkboxValue),
      title: Text(storeNotifier.toppingList[index].name),
      trailing: Text('+' + storeNotifier.toppingList[index].price),
    );
  }

  Widget checkbox(bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {},
        )
      ],
    );
  }
}
