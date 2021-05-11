import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Customer {
  String uid;
  String userName;
  String email;
  String password;
  String address;
  GeoPoint realtimeLocation;

  Customer();

  Customer.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    userName = data['userName'];
    email = data['email'];
    password = data['password'];
    address = data['address'];
    realtimeLocation = data['realtimeLocation'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'password': password,
      'address': address,
      'realtimeLocation': realtimeLocation
    };
  }
}
