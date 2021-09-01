import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/address.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/models/user.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';

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

  void updateUserData(Map<String, dynamic> value) {
    firebaseFirestore.collection(collection).doc(value['uid']).update(value);
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

String orderId;

saveDeliveryOrder(
  String storeId,
  String customerName,
  String phone,
  String address,
  String addreeDetail,
  GeoPoint geoPoint,
  String netPrice,
  String message,
) async {
  Timestamp orderedAt = Timestamp.now();

  DocumentReference orderRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc();

  orderId = orderRef.id;

  await orderRef.set({
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'addressDetail': addreeDetail,
    'geoPoint': geoPoint,
    'netPrice': netPrice,
    'message': message,
    'orderedAt': orderedAt
  });

  print('Saved to Firebase');
  print(orderRef.id);
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
