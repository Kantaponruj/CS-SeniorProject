import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/address.dart';
import 'package:cs_senior_project/models/favorite.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/models/user.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/favorite_notifier.dart';

class UserService {
  String collection = "users";

  void createUser({
    String uid,
    String displayName,
    String email,
    String token,
  }) {
    AddressModel addressModel = AddressModel();
    String residentName = addressModel.residentName;
    String address = addressModel.address;
    String addressDetail = addressModel.addressDetail;
    GeoPoint geoPoint = addressModel.geoPoint;
    String phone = addressModel.phone;

    residentName = "";
    address = "";
    addressDetail = "";
    geoPoint = GeoPoint(0, 0);
    phone = "";

    firebaseFirestore.collection(collection).doc(uid).set({
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'token': token,
      'selectedAddress': {
        'residentName': residentName,
        'address': address,
        'addressDetail': addressDetail,
        'geoPoint': geoPoint,
        'phone': phone
      }
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

// Address
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

addAddress(AddressModel address, String uid, Function addAddress) async {
  CollectionReference addressRef =
      firebaseFirestore.collection('users').doc(uid).collection('address');

  DocumentReference documentRef = await addressRef.add(address.toMap());
  await documentRef.set(address.toMap(), SetOptions(merge: true));

  addAddress(address);
}

// History
String orderId;

saveToHistory(
  String uid,
  String storeId,
  String storeName,
  String customerName,
  String phone,
  String address,
  String addressDetail,
  GeoPoint geoPoint,
  String netPrice,
  String message,
) async {
  DocumentReference orderRef = firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc();

  orderId = orderRef.id;

  await orderRef.set({
    'orderId': orderId,
    'storeId': storeId,
    'storeName': storeName,
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'addressDetail': addressDetail,
    'geoPoint': geoPoint,
    'netPrice': netPrice,
    'message': message,
    'orderedAt': Timestamp.now()
  });
}

saveOrderToHistory(String uid, OrderModel order) async {
  CollectionReference orderToppingRef = firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc(orderId)
      .collection('orders');

  DocumentReference documentRef = await orderToppingRef.add(order.toMap());
  await documentRef.set(order.toMap(), SetOptions(merge: true));
}

// Favorite Stores
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
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('favorites')
      .get();

  List<Favorite> _favoriteList = [];

  snapshot.docs.forEach((document) {
    Favorite favorite = Favorite.fromMap(document.data());
    _favoriteList.add(favorite);
  });

  favNotifier.favoriteList = _favoriteList;
}
