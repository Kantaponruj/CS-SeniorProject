import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopDetail extends StatefulWidget {
  ShopDetail({Key key}) : super(key: key);

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getDateAndTime(storeNotifier, storeNotifier.currentStore.storeId);
    super.initState();
  }

  int textCase;
  List daysArr = [];
  List<String> _days = [
    'วันจันทร์',
    'วันอังคาร',
    'วันพุธ',
    'วันพฤหัสบดี',
    'วันศุกร์',
    'วันเสาร์',
    'วันอาทิตย์'
  ];

  showDateTime(int index, StoreOpenDateTime dateTime) {
    if (dateTime.dates.length >= 2) {
      daysArr = [];
      for (int i = 0; i < dateTime.dates.length - 1; i++) {
        if ((dateTime.dates[i].isOdd && dateTime.dates[i + 1].isEven) ||
            (dateTime.dates[i].isEven && dateTime.dates[i + 1].isOdd)) {
          daysArr.add(_days[dateTime.dates[i]]);
          textCase = 1;
        } else {
          daysArr.add(_days[dateTime.dates[i]]);
          textCase = 2;
        }
      }

      daysArr.add(_days[dateTime.dates[dateTime.dates.length - 1]]);

      return Container(
        child: textCase == 1
            ? Text(
                daysArr[0] + " - " + daysArr[daysArr.length - 1],
                style: FontCollection.bodyTextStyle,
              )
            : Row(
                children: [
                  Text(daysArr.join(', '), style: FontCollection.bodyTextStyle)
                ],
              ),
      );
    } else {
      daysArr = [];
      daysArr.add(_days[dateTime.dates[0]]);

      return Container(
        child: Text(
          daysArr[0],
          style: FontCollection.bodyTextStyle,
        ),
      );
    }
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
                        child: storeNotifier.currentStore.image.isNotEmpty
                            ? Image.network(
                                storeNotifier.currentStore.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Image.asset(
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
                            alignment: Alignment.centerLeft,
                            child: Text(
                              storeNotifier.currentStore.description,
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
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: storeNotifier.dateTimeList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      showDateTime(
                                        index,
                                        storeNotifier.dateTimeList[index],
                                      ),
                                      Container(
                                        child: Text(
                                          storeNotifier.dateTimeList[index]
                                                  .openTime +
                                              " - " +
                                              storeNotifier.dateTimeList[index]
                                                  .closeTime,
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                                    storeNotifier.currentStore.addressName,
                                    style: FontCollection.bodyBoldTextStyle,
                                  ),
                                ),
                                Container(
                                  child: AutoSizeText(
                                    storeNotifier.currentStore.address,
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
