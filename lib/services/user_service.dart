import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/address.dart';
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
    firebaseFirestore.collection(collection).doc(uid).set({
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'token': token
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
