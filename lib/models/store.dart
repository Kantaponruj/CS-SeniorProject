import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  bool isDelivery;
  bool isPickUp;
  String storeCategory;
  String storeName;
  String kindOfFood;
  String image;
  String phone;
  String startTime;
  String endTime;
  String address;
  GeoPoint location;

  Store();

  Store.fromMap(Map<String, dynamic> data) {
    storeId = data['storeId'];
    isDelivery = data['isDelivery'];
    isPickUp = data['isPickUp'];
    storeCategory = data['storeCategory'];
    storeName = data['storeName'];
    kindOfFood = data['kindOfFood'];
    image = data['image'];
    phone = data['phone'];
    startTime = data['startTime'];
    endTime = data['endTime'];
    address = data['currentAddress'];
    location = data['currentLocation'];
  }
}
