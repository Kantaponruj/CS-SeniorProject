import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_stores/helper/constant.dart';
import 'package:google_map_stores/models/user.dart';

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
      'token': token,
      // "position": position,
    });
  }

  void updateUserData(Map<String, dynamic> value) {
    firebaseFirestore.collection(collection).doc(value['uid']).update(value);
  }

  void addDeviceToken({String uid, String token}) {
    firebaseFirestore.collection(collection).doc(uid).update({'token': token});
  }

  void addUserLocation({String uid, String address, Position position}) {
    firebaseFirestore.collection(collection).doc(uid).update({
      'address': address,
      'realtimeLocation': GeoPoint(position.latitude, position.longitude)
    });
  }

  Future<UserModel> getUserById(String uid) =>
      firebaseFirestore.collection(collection).doc(uid).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
