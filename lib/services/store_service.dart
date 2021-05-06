import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_map_stores/models/store.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';

getStores(StoreNotifier storeNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('stores').get();

  List<Store> _storeList = [];

  snapshot.docs.forEach((document) {
    Store store = Store.fromMap(document.data());
    _storeList.add(store);
  });

  storeNotifier.storeList = _storeList;
}
