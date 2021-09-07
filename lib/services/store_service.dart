import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';

String collection = 'stores';

Future<void> getStores(StoreNotifier storeNotifier, String tapName) async {
  QuerySnapshot snapshot;

  switch (tapName) {
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
      snapshot = await firebaseFirestore.collection(collection).get();
      break;
  }

  List<Store> _storeList = [];

  snapshot.docs.forEach((document) {
    Store store = Store.fromMap(document.data());
    _storeList.add(store);
  });

  storeNotifier.storeList = _storeList;
}

Future<void> getMenu(StoreNotifier storeNotifier) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection(collection)
      .doc(storeNotifier.currentStore.storeId)
      .collection('menu')
      .get();

  List<MenuModel> _menuList = [];

  snapshot.docs.forEach((document) {
    MenuModel menu = MenuModel.fromMap(document.data());
    _menuList.add(menu);
  });

  storeNotifier.menuList = _menuList;
}

Future<void> getTopping(
    StoreNotifier storeNotifier, String storeId, String menuId) async {
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

Future<void> getDateAndTime(StoreNotifier storeNotifier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection(collection)
      .doc(storeId)
      .collection('openingHours')
      .get();

  List<StoreOpenDateTime> _dateTime = [];

  snapshot.docs.forEach((document) {
    StoreOpenDateTime dateTime = StoreOpenDateTime.fromMap(document.data());
    _dateTime.add(dateTime);
  });

  storeNotifier.dateTimeList = _dateTime;
}

String orderId;

saveDeliveryOrder(String storeId, Activities activity) async {
  DocumentReference orderRefStore = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc();

  orderId = orderRefStore.id;
  activity.orderId = orderId;

  orderRefStore.set(activity.toMap(), SetOptions(merge: true));
}

saveOrder(String storeId, OrderModel order) async {
  CollectionReference orderToppingRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc(orderId)
      .collection('orders');

  DocumentReference documentRef = await orderToppingRef.add(order.toMap());
  await documentRef.set(order.toMap(), SetOptions(merge: true));
}
