class OrderModel {
  String storeId;
  String menuId;
  String menuName;
  String totalPrice;
  List topping;
  int amount;
  String other;

  OrderModel();

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'menuId': menuId,
      'menuName': menuName,
      'totalPrice': totalPrice,
      'topping': topping,
      'amount': amount,
      'other': other
    };
  }

  OrderModel.fromMap(Map<String, dynamic> data) {
    storeId = data['storeId'];
    menuId = data['menuId'];
    menuName = data['menuName'];
    totalPrice = data['totalPrice'];
    topping = data['topping'];
    amount = data['amount'];
    other = data['other'];
  }
}
