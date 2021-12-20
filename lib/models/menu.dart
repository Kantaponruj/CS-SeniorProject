class MenuModel {
  String menuId;
  String name;
  String description;
  String image;
  String price;
  String categoryFood;

  // MenuModel();

  MenuModel.fromMap(Map<String, dynamic> data) {
    menuId = data["menuId"];
    name = data["name"];
    description = data["description"];
    image = data["image"];
    price = data["price"];
    categoryFood = data["categoryFood"];
  }
}

class ToppingModel {
  String toppingId;
  String type;
  String selectedNumberTopping;
  String topic;
  String detail;
  List<dynamic> subTopping = [];
  bool require;

  ToppingModel.fromMap(Map<String, dynamic> data) {
    toppingId = data['toppingId'];
    type = data['type'];
    selectedNumberTopping = data['selectedNumberTopping'];
    topic = data['topic'];
    detail = data['detail'];
    subTopping = data['subTopping'];
    require = data['require'];
  }
}
