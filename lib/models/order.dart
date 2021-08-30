class OrderModel {
  String menuId;
  String menuName;
  String totalPrice;
  List topping;

  OrderModel();

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'totalPrice': totalPrice,
      'topping': topping
    };
  }

  OrderModel.fromMap(Map<String, dynamic> data) {
    menuId = data['menuId'];
    menuName = data['menuName'];
    totalPrice = data['totalPrice'];
    topping = data['topping'];
  }
}
