import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  bool isDelivery;
  bool isPickUp;
  String storeName;
  String kindOfFood;
  String image;
  String phone;
  String address;
  String addressName;
  GeoPoint location;
  String description;
  GeoPoint realtimeLocation;

  // Store();

  Store.fromMap(Map<String, dynamic> data) {
    storeId = data['storeId'];
    isDelivery = data['isDelivery'];
    isPickUp = data['isPickUp'];
    storeName = data['storeName'];
    kindOfFood = data['kindOfFood'];
    image = data['image'];
    phone = data['phone'];
    address = data['selectedAddress'];
    addressName = data['selectedAddressName'];
    location = data['selectedLocation'];
    description = data['description'];
    realtimeLocation = data['realtimeLocation'];
  }
}

class StoreOpenDateTime {
  String openTime;
  String closeTime;
  List dates = [];

  StoreOpenDateTime.fromMap(Map<String, dynamic> data) {
    openTime = data['openTime'];
    closeTime = data['closeTime'];
    dates = data['date'];
  }
}
