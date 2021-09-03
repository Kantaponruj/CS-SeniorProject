import 'package:cloud_firestore/cloud_firestore.dart';

class Activities {
  String orderId;
  String customerName;
  String phone;
  String address;
  String addressDetail;
  GeoPoint geoPoint;
  String message;
  String dateOrdered;
  String timeOrdered;
  String netPrice;
  String storeId;
  String storeName;
  String storeImage;
  String kindOfFood;

  Activities();

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint,
      'message': message,
      'dateOrdered': dateOrdered,
      'timeOrdered': timeOrdered,
      'netPrice': netPrice,
      'storeId': storeId,
      'storeName': storeName,
      'storeImage': storeImage,
      'kindOfFood': kindOfFood
    };
  }

  Activities.fromMap(Map<String, dynamic> data) {
    orderId = data['orderId'];
    customerName = data['customerName'];
    phone = data['phone'];
    address = data['address'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
    message = data['message'];
    dateOrdered = data['dateOrdered'];
    timeOrdered = data['timeOrdered'];
    netPrice = data['netPrice'];
    storeId = data['storeId'];
    storeName = data['storeName'];
    storeImage = data['storeImage'];
    kindOfFood = data['kindOfFood'];
  }
}
