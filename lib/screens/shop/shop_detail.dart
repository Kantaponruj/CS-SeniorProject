import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopDetail extends StatefulWidget {
  ShopDetail({Key key, this.storeId}) : super(key: key);

  final String storeId;

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getMenu(storeNotifier, widget.storeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTitle: storeNotifier.currentStore.storeName,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                    // padding: EdgeInsets.only(top: 80),
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/shop_test.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ]),
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        BuildCard(
                          headerText: 'รายละเอียดร้านค้า',
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Condimentum blandit nisl et ullamcorper netus. Consequat dui pulvinar ligula posuere vestibulum. Sit est viverra nibh ',
                              style: FontCollection.bodyTextStyle,
                            ),
                          ),
                          canEdit: false,
                        ),
                        BuildCard(
                          headerText: 'เวลาทำการ',
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          'จันทร์ - ศุกร์',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '9.00 - 12.00 น.',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          'จันทร์ - ศุกร์',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '9.00 - 12.00 น.',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          canEdit: false,
                        ),
                        BuildCard(
                          headerText: 'สถานที่ขาย',
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'ตลาดทุ่งครุ',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                                Container(
                                  child: AutoSizeText(
                                    'ตลาดทุ่งครุ ประชาอุทิศ 61 ถนนประชาอุทิศ แขวงทุ่งครุ เขตทุ่งครุ 10140',
                                    maxLines: 2,
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          canEdit: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
