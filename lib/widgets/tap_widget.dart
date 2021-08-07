
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/screens/shop/shop_menu.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TapWidget extends StatelessWidget {
  const TapWidget({Key key, @required this.scrollController, this.tapName})
      : super(key: key);
  final ScrollController scrollController;
  final String tapName;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    switch (tapName) {
      case "all":
        getStores(storeNotifier, tapName);
        break;
      case "delivery":
        getStores(storeNotifier, tapName);
        break;
      case "pickup":
        getStores(storeNotifier, tapName);
        break;
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      controller: scrollController,
      itemCount: storeNotifier.storeList.length,
      itemBuilder: (context, index) {
        final store = storeNotifier.storeList[index];
        return Column(
          children: [
            buildStore(store, context)],
        );
      },
    );
  }

  Widget buildStore(Store store, context) => ListTile(
        leading: Image.network(
          store.image != null
              ? store.image
              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return Icon(Icons.image, size: 40.0);
          },
          width: 100,
          fit: BoxFit.cover,
        ),
        title: Text(
          store.storeName,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text('ของหวาน'),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShopMenu(),));
        }
      );
}
