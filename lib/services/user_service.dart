import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/user.dart';

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

  // void addUserLocation({String uid, String address, Position position}) {
  //   firebaseFirestore.collection(collection).doc(uid).update({
  //     'address': address,
  //     'realtimeLocation': GeoPoint(position.latitude, position.longitude)
  //   });
  // }

  Future<UserModel> getUserById(String uid) => firebaseFirestore
      .collection(collection)
      .doc(uid)
      .get()
      .then((doc) => UserModel.fromSnapshot(doc));
}
