import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';

String collection = 'stores';

Future<void> getStores(StoreNotifier storeNotifier, String tapName) async {
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

Future<void> getMenu(StoreNotifier storeNotifier, String storeId) async {
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

Future<void> getTopping(StoreNotifier storeNotifier, String storeId, String menuId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection(collection)
      .doc(storeId)
      .collection('menu')
      .doc(menuId)
      .collection('topping')
      .get();

  List<ToppingModel> _toppingList = [];

  snapshot.docs.forEach((document) {
    ToppingModel topping = ToppingModel.fromMap(document.data());
    _toppingList.add(topping);
  });

  storeNotifier.toppingList = _toppingList;
}
