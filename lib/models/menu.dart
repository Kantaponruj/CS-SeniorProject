class MenuModel {
  String menuId;
  String name;
  String description;
  String image;
  String price;

  MenuModel();

  MenuModel.fromMap(Map<String, dynamic> data) {
    menuId = data["menuId"];
    name = data["name"];
    description = data["description"];
    image = data["image"];
    price = data["price"];
  }
}

class ToppingModel {
  String name;
  String price;

  ToppingModel();

  ToppingModel.fromMap(Map<String, dynamic> data) {
    name = data["name"];
    price = data["price"];
  }
}
