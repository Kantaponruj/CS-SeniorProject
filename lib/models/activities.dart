import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String orderId;
  String customerId;
  String customerName;
  String phone;
  String address;
  String addressName;
  String addressDetail;
  GeoPoint geoPoint;
  String message;
  String dateOrdered;
  String timeOrdered;
  String netPrice;
  String storeId;
  String storeName;
  String storeImage;
  List kindOfFood;
  String orderStatus;
  String amountOfMenu;

  Activity();

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'addressName': addressName,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint,
      'message': message,
      'dateOrdered': dateOrdered,
      'timeOrdered': timeOrdered,
      'netPrice': netPrice,
      'storeId': storeId,
      'storeName': storeName,
      'storeImage': storeImage,
      'kindOfFood': kindOfFood,
      'orderStatus': orderStatus,
      'amountOfMenu': amountOfMenu
    };
  }

  Activity.fromMap(Map<String, dynamic> data) {
    orderId = data['orderId'];
    customerId = data['customerId'];
    customerName = data['customerName'];
    phone = data['phone'];
    address = data['address'];
    addressName = data['addressName'];
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
    orderStatus = data['orderStatus'];
  }
}
