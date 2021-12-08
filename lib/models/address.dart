import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String addressId;
  String address = '';
  String addressName = '';
  String addressDetail = '';
  GeoPoint geoPoint = GeoPoint(0, 0);
  String residentName = '';
  String phone = '';

  AddressModel();

  AddressModel.fromMap(Map<String, dynamic> data) {
    addressId = data['addressId'];
    address = data['address'];
    addressName = data['addressName'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
    residentName = data['residentName'];
    phone = data['phone'];
  }

  Map<String, dynamic> toMap() {
    return {
      'addressId': addressId,
      'address': address,
      'addressName': addressName,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint,
      'residentName': residentName,
      'phone': phone
    };
  }
}
