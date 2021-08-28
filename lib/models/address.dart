import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String address;
  String addressName;
  String addressDetail;
  GeoPoint geoPoint;
  String residentName;
  String phone;

  AddressModel();

  // AddressModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   address = snapshot.data()["address"];
  //   addressName = snapshot.data()["addressName"];
  //   addressDetail = snapshot.data()["addressDetail"];
  //   geoPoint = snapshot.data()["geoPoint"];
  //   residentName = snapshot.data()["residentName"];
  //   phone = snapshot.data()["phone"];
  //   other = snapshot.data()["other"];
  // }

  AddressModel.fromMap(Map<String, dynamic> data) {
    address = data['address'];
    addressName = data['addressName'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
    residentName = data['residentName'];
    phone = data['phone'];
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'addressName': addressName,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint,
      'residentName': residentName,
      'phone': phone
    };
  }
}
