import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:cs_senior_project/models/address.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/models/user.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/services/store_service.dart';

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
    String addressName = addressModel.addressName;
    String addressDetail = addressModel.addressDetail;
    GeoPoint geoPoint = addressModel.geoPoint;
    String phone = addressModel.phone;

    residentName = "";
    address = "";
    addressName = "";
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
        'addressName': addressName,
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

addAddress(AddressModel address, String uid, Function addAddress) async {
  CollectionReference addressRef =
      firebaseFirestore.collection('users').doc(uid).collection('address');

  DocumentReference documentRef = await addressRef.add(address.toMap());
  await documentRef.set(address.toMap(), SetOptions(merge: true));

  addAddress(address);
}

// activities & histoy

String orderId;

saveActivityToHistory(String uid, String storeId, Activity activity) async {
  DocumentReference orderRef = firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc();

  orderId = orderRef.id;
  activity.orderId = orderId;

  orderRef.set(activity.toMap(), SetOptions(merge: true));

  saveDeliveryOrder(storeId, activity);
}

saveEachOrderToHistory(String uid, String storeId, OrderModel order) async {
  CollectionReference orderToppingRef = firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc(orderId)
      .collection('orders');

  DocumentReference documentRef = await orderToppingRef.add(order.toMap());
  await documentRef.set(order.toMap(), SetOptions(merge: true));

  saveEachOrder(storeId, order);
}

Future<void> getHistoryOrder(
    ActivitiesNotifier activitiesNotifier, String uid) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .get();

  List<Activity> _activityList = [];

  snapshot.docs.forEach((document) {
    Activity activity = Activity.fromMap(document.data());
    _activityList.add(activity);
  });

  activitiesNotifier.activitiesList = _activityList;
}

Future<Activity> getActivityById(String uid) => firebaseFirestore
    .collection('users')
    .doc(uid)
    .collection('activities')
    .doc(orderId)
    .get()
    .then((doc) => Activity.fromMap(doc.data()));
