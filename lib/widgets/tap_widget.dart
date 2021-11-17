import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_menu.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TapWidget extends StatefulWidget {
  TapWidget({Key key, @required this.scrollController, this.isDelivery})
      : super(key: key);

  final ScrollController scrollController;
  final bool isDelivery;

  @override
  _TapWidgetState createState() => _TapWidgetState();
}

class _TapWidgetState extends State<TapWidget> {
  List<Store> _storeList = [];

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return StreamBuilder(
      stream: getStores(widget.isDelivery),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        _storeList.clear();

        if (!snapshot.hasData) {
          return LoadingWidget();
        }

        snapshot.data.docs.forEach((document) {
          Store store = Store.fromMap(document.data());
          _storeList.add(store);
        });

        storeNotifier.storeList = _storeList;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          controller: widget.scrollController,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            final store = snapshot.data.docs[index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: buildStore(store, context, storeNotifier),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget buildStore(final store, context, StoreNotifier storeNotifier) {
    return ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  store['image'] != null
                      ? store['image']
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                ),
              )),
        ),
        title: Text(
          store['storeName'],
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(store['kindOfFood'].join(', ')),
        onTap: () {
          _storeList.forEach((element) {
            if (element.storeId == store['storeId']) {
              storeNotifier.currentStore = element;
              // print('data id: ${element.storeId}');
              // print('store id: ${store['storeId']}');
            }
          });

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShopMenu(),
          ));
        });
  }
}
