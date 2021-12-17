import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  bool isDelivery;
  bool isPickUp;
  String storeName;
  List kindOfFood;
  String image;
  String phone;
  String address;
  String addressName;
  GeoPoint location;
  String description;
  GeoPoint realtimeLocation;
  bool storeStatus;
  String typeOfStore;
  String shippingfee;
  String distanceForOrder;

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
    storeStatus = data['storeStatus'];
    typeOfStore = data['typeOfStore'];
    shippingfee = data['shippingfee'];
    distanceForOrder = data['distanceForOrder'];
  }

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'isDelivery': isDelivery,
      'isPickUp': isPickUp,
      'storeName': storeName,
      'kindOfFood': kindOfFood,
      'image': image,
      'phone': phone,
      'selectedAddress': address,
      'selectedAddressName': addressName,
      'selectedLocation': location,
      'description': description,
      'realtimeLocation': realtimeLocation,
      'storeStatus': storeStatus,
      'typeOfStore': typeOfStore,
      'shippingfee': shippingfee,
      'distanceForOrder': distanceForOrder,
    };
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
