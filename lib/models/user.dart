import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // static const UID = "uid";
  // static const DISPLAYNAME = "displayName";
  // static const EMAIL = "email";
  // static const ADDRESS = "address";
  // static const PHONE = "phone";
  // static const TOKEN = "token";
  // static const IMAGE = "image";
  // static const REALTIMELOCATION = "realtimeLocation";

  String _uid;
  String _displayName;
  String _email;
  String _address;
  String _phone;
  String _token;
  String _image;
  GeoPoint _realtimeLocation;

  // getter
  String get uid => _uid;
  String get displayName => _displayName;
  String get email => _email;
  String get address => _address;
  String get phone => _phone;
  String get token => _token;
  String get image => _image;
  GeoPoint get realtimeLocation => _realtimeLocation;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _uid = snapshot.data()["uid"];
    _displayName = snapshot.data()["displayName"];
    _email = snapshot.data()["email"];
    _address = snapshot.data()["address"];
    _phone = snapshot.data()["phone"];
    _token = snapshot.data()["token"];
    _image = snapshot.data()["image"];
    _realtimeLocation = snapshot.data()["realtimeLocation"];
  }
}
