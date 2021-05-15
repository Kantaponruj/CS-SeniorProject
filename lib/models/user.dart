import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const UID = "uid";
  static const DISPLAYNAME = "displayName";
  static const EMAIL = "email";
  static const ADDRESS = "address";
  static const PHONE = "phone";
  static const TOKEN = "token";
  static const IMAGE = "image";

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
    _uid = snapshot.data()[UID];
    _displayName = snapshot.data()[DISPLAYNAME];
    _email = snapshot.data()[EMAIL];
    _address = snapshot.data()[ADDRESS];
    _phone = snapshot.data()[PHONE];
    _token = snapshot.data()[TOKEN];
    _image = snapshot.data()[IMAGE];
    _realtimeLocation = snapshot.data()[realtimeLocation];
  }
}
