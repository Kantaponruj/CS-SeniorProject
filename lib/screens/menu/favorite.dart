import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/favorite_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_menu.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    FavoriteNotifier fav =
        Provider.of<FavoriteNotifier>(context, listen: false);
    getFavoriteStores(fav, widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteNotifier fav = Provider.of<FavoriteNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'บันทึก',
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: fav.favStoresList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return listCard(fav.favStoresList[index], storeNotifier);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listCard(Store store, StoreNotifier storeNotifier) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          leading: Container(
            child: CircleAvatar(
              backgroundColor: CollectionsColors.yellow,
              radius: 40.0,
              // child: Text(
              //   nameUpperCase,
              //   style: FontCollection.topicBoldTextStyle,
              //   textAlign: TextAlign.left,
              // ),
              backgroundImage: NetworkImage(store.image),
            ),
          ),
          title: Text(
            store.storeName,
            style: FontCollection.bodyTextStyle,
          ),
          subtitle: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      store.kindOfFood.join(', '),
                      style: FontCollection.smallBodyTextStyle,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: CollectionsColors.yellow,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        child: Text(
                          store.isDelivery ? 'จัดส่ง' : 'รับเอง',
                          style: FontCollection.descriptionTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          onTap: () {
            storeNotifier.currentStore = store;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShopMenu(),
            ));
          },
        ),
      ),
    );
  }
}
