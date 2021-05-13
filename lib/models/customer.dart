import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String uid;
  String displayName;
  String email;
  String password;
  String address;
  GeoPoint realtimeLocation;

  Customer();

  Customer.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    displayName = data['displayName'];
    email = data['email'];
    password = data['password'];
    address = data['address'];
    realtimeLocation = data['realtimeLocation'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'password': password,
      'address': address,
      'realtimeLocation': realtimeLocation
    };
  }
}
