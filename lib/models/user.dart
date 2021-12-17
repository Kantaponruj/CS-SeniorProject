import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _uid;
  String _displayName;
  String _email;
  String _phone;

  // getter
  String get uid => _uid;
  String get displayName => _displayName;
  String get email => _email;
  String get phone => _phone;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _uid = snapshot.data()["uid"];
    _displayName = snapshot.data()["displayName"];
    _email = snapshot.data()["email"];
    _phone = snapshot.data()["phone"];
  }
}
