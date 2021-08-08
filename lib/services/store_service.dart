import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';

String collection = 'stores';

getStores(StoreNotifier storeNotifier, String tapName) async {
  QuerySnapshot snapshot;

  switch (tapName) {
    case "all":
      snapshot = await firebaseFirestore.collection(collection).get();
      break;
    case "delivery":
      snapshot = await firebaseFirestore
          .collection(collection)
          .where('isDelivery', isEqualTo: true)
          .get();
      break;
    case "pickup":
      snapshot = snapshot = await firebaseFirestore
          .collection(collection)
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

getMenu(StoreNotifier storeNotifier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection(collection)
      .doc(storeId)
      .collection('menu')
      .get();

  List<MenuModel> _menuList = [];

  snapshot.docs.forEach((document) {
    MenuModel menu = MenuModel.fromMap(document.data());
    _menuList.add(menu);
  });

  storeNotifier.menuList = _menuList;
}
