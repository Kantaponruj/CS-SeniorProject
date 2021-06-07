import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';

getStores(StoreNotifier storeNotifier, String tapName) async {
  QuerySnapshot snapshot;

  switch (tapName) {
    case "all":
      snapshot = await FirebaseFirestore.instance.collection('stores').get();
      break;
    case "delivery":
      snapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('isDelivery', isEqualTo: true)
          .get();
      break;
    case "pickup":
      snapshot = snapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('isPickUp', isEqualTo: true)
          .get();
      break;
    default:
      break;
  }

  List<Store> _storeList = [];

  snapshot.docs.forEach((document) {
    Store store = Store.fromMap(document.data());
    _storeList.add(store);
  });

  storeNotifier.storeList = _storeList;
}
