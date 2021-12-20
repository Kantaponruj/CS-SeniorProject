import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/models/address.dart';
import 'package:cs_senior_project/models/favorite.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/models/user.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/favorite_notifier.dart';
import 'package:cs_senior_project/services/store_service.dart';

class UserService {
  String collection = "users";

  void createUser({
    String uid,
    String displayName,
    String email,
    String phone,
  }) {
    firebaseFirestore.collection(collection).doc(uid).set({
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phone': phone,
    });
  }

  void updateUserData(String uid, Map<String, dynamic> value) {
    firebaseFirestore.collection(collection).doc(uid).update(value);
  }

  void addDeviceToken({String uid, String token}) {
    firebaseFirestore.collection(collection).doc(uid).update({'token': token});
  }

  Future<UserModel> getUserById(String uid) => firebaseFirestore
      .collection(collection)
      .doc(uid)
      .get()
      .then((doc) => UserModel.fromSnapshot(doc));
}

// address
Future<void> getAddress(AddressNotifier addressNotifier, String uid) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('address')
      .get();

  List<AddressModel> _addressList = [];

  snapshot.docs.forEach((document) {
    AddressModel address = AddressModel.fromMap(document.data());
    _addressList.add(address);
  });

  addressNotifier.addressList = _addressList;
}

addAddress(AddressModel address, String uid, bool isUpdating,
    Function addAddress) async {
  CollectionReference addressRef =
      firebaseFirestore.collection('users').doc(uid).collection('address');

  if (isUpdating) {
    await addressRef.doc(address.addressId).update(address.toMap());
  } else {
    DocumentReference documentRef = await addressRef.add(address.toMap());
    address.addressId = documentRef.id;
    await documentRef.set(address.toMap(), SetOptions(merge: true));
  }
  addAddress(address);
}

deleteAddress(String uid, AddressModel address, Function onDeleted) {
  firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('address')
      .doc(address.addressId)
      .delete();

  onDeleted(address);
}

// activities & histoy
String orderId;

saveActivityToHistory(
    String uid, String storeId, Activity activity, String typeOrder) async {
  DocumentReference orderRef = firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc();

  orderId = orderRef.id;
  activity.orderId = orderId;

  orderRef.set(activity.toMap(), SetOptions(merge: true));

  saveOrder(typeOrder, storeId, activity);
}

saveEachOrderToHistory(
    String uid, String storeId, OrderModel order, String typeOrder) async {
  CollectionReference orderToppingRef = firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc(orderId)
      .collection('orders');

  DocumentReference documentRef = await orderToppingRef.add(order.toMap());
  await documentRef.set(order.toMap(), SetOptions(merge: true));

  saveEachOrder(typeOrder, storeId, order);
}

Future<void> getHistoryOrder(
    ActivitiesNotifier activitiesNotifier, String uid) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .orderBy('dateOrdered', descending: true)
      .limit(20)
      .get();

  List<Activity> _activityList = [];

  snapshot.docs.forEach((document) {
    Activity activity = Activity.fromMap(document.data());
    _activityList.add(activity);
  });

  activitiesNotifier.activitiesList = _activityList;
}

Future<void> getOrderMenu(
  ActivitiesNotifier activitiesNotifier,
  String uid,
  String activityId,
) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc(activityId)
      .collection('orders')
      .get();

  List<OrderModel> _orderMenuList = [];

  snapshot.docs.forEach((document) {
    OrderModel order = OrderModel.fromMap(document.data());
    _orderMenuList.add(order);
  });

  activitiesNotifier.orderMenuList = _orderMenuList;
}

Future<Activity> getActivityById(String uid, String orderId) =>
    firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('activities')
        .doc(orderId)
        .get()
        .then((doc) => Activity.fromMap(doc.data()));

// favorite store
saveFavoriteStore(Favorite favorite, String uid, Function saveFavorite) async {
  CollectionReference favRef =
      firebaseFirestore.collection('users').doc(uid).collection('favorites');

  DocumentReference docRef = await favRef.add(favorite.toMap());
  favorite.favId = docRef.id;
  await docRef.set(favorite.toMap(), SetOptions(merge: true));

  saveFavorite(favorite);
}

deleteFavoriteStore(Favorite favorite, Function deleteFav, String uid) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('favorites')
      .doc(favorite.favId)
      .delete();

  deleteFav(favorite);
}

Future<void> getFavoriteStores(FavoriteNotifier favNotifier, String uid) async {
  QuerySnapshot snapshotStore =
      await firebaseFirestore.collection('stores').get();
  List<Store> _storeList = [];

  snapshotStore.docs.forEach((document) {
    Store store = Store.fromMap(document.data());
    _storeList.add(store);
  });

  QuerySnapshot snapshot = await firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('favorites')
      .get();
  List<Favorite> _favoriteList = [];
  List<Store> _favStoresList = [];

  snapshot.docs.forEach((document) {
    Favorite favorite = Favorite.fromMap(document.data());
    _favoriteList.add(favorite);

    _storeList.forEach((store) {
      if (store.storeId == favorite.storeId) {
        _favStoresList.add(store);
      }
    });
  });

  favNotifier.favoriteList = _favoriteList;
  favNotifier.favStoresList = _favStoresList;
}
