import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String address;
  String addressName;
  String addressDetail;
  GeoPoint geoPoint;

  AddressModel();

  AddressModel.fromSnapshot(DocumentSnapshot snapshot) {
    address = snapshot.data()["address"];
    addressName = snapshot.data()["addressName"];
    addressDetail = snapshot.data()["addressDetail"];
    geoPoint = snapshot.data()["geoPoint"];
  }

  AddressModel.fromMap(Map<String, dynamic> data) {
    address = data['address'];
    addressName = data['addressName'];
    addressDetail = data['addressDetail'];
  }
}
