import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/storeNotifier.dart';
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
    if (tapName == "all") {
      getStores(storeNotifier, tapName);
    }
    if (tapName == "delivery") {
      getStores(storeNotifier, tapName);
    }
    if (tapName == "pickup") {
      getStores(storeNotifier, tapName);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      controller: scrollController,
      itemCount: storeNotifier.storeList.length,
      itemBuilder: (context, index) {
        final store = storeNotifier.storeList[index];
        return Column(
          children: [
            buildStore(store),
          ],
        );
      },
    );
  }

  Widget buildStore(Store store) => ListTile(
        leading: Image.network(
          store.image != null
              ? store.image
              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
          width: 100,
          fit: BoxFit.cover,
        ),
        title: Text(
          store.name,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text('ของหวาน'),
        onTap: () async {},
      );
}
