class Favorite {
  String favId;
  String storeId;

  Favorite();

  Map<String, dynamic> toMap() {
    return {'favoriteId': favId, 'storeId': storeId};
  }

  Favorite.fromMap(Map<String, dynamic> data) {
    favId = data['favoriteId'];
    storeId = data['storeId'];
  }
}
