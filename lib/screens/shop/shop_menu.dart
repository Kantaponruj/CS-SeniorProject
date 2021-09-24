import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/favorite.dart';
import 'package:cs_senior_project/notifiers/favorite_notifier.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/order/orderDetail.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopMenu extends StatefulWidget {
  ShopMenu({Key key}) : super(key: key);

  @override
  _ShopMenuState createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  int index = 0;
  final items = List.generate(10, (counter) => 'Item: $counter');
  final controller = ScrollController();

  List categories = [];

  Favorite _favorite = Favorite();
  int _favIndex;
  bool _isFavorite = false;

  @override
  void initState() {
    FavoriteNotifier favNotifier =
        Provider.of<FavoriteNotifier>(context, listen: false);
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getMenu(storeNotifier, storeNotifier.currentStore.storeId);
    getFavoriteStores(favNotifier, userNotifier.user.uid);

    if (favNotifier.favoriteList != null) {
      for (int i = 0; i < favNotifier.favoriteList.length; i++) {
        if (favNotifier.favoriteList[i].storeId ==
            storeNotifier.currentStore.storeId) {
          _isFavorite = true;
          _favIndex = i;
          break;
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    FavoriteNotifier favNotifier = Provider.of<FavoriteNotifier>(context);

    categories.clear();
    storeNotifier.menuList.forEach((menu) {
      if (categories.contains(menu.categoryFood)) {
      } else {
        categories.add(menu.categoryFood);
      }
    });

    _onSaveFavorite(Favorite favorite) {
      _isFavorite = true;
      favNotifier.addFavorite(favorite);
    }

    _onDeleteFavorite(Favorite favorite) {
      _isFavorite = false;
      favNotifier.deleteFavorite(favorite);
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ShopRoundedAppBar(
          appBarTitle: storeNotifier.currentStore.storeName,
          onClicked: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShopDetail(),
            ));
          },
          onSaved: () {
            _favorite.storeId = storeNotifier.currentStore.storeId;
            _isFavorite
                ? deleteFavoriteStore(
                    favNotifier.favoriteList[_favIndex],
                    _onDeleteFavorite,
                    userNotifier.user.uid,
                  )
                : saveFavoriteStore(
                    _favorite,
                    userNotifier.user.uid,
                    _onSaveFavorite,
                  );
          },
          isFavorite: _isFavorite,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  // padding: EdgeInsets.only(top: 80),
                  children: [
                    Expanded(
                      child: Image.network(
                        storeNotifier.currentStore.image != null
                            ? storeNotifier.currentStore.image
                            : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Icon(Icons.image, size: 40.0);
                        },
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: buildHorizontalListView(),
                ),
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        BuildCard(
                          headerText: 'การนัดหมาย/จัดส่ง',
                          child: Container(),
                          canEdit: false,
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return menuCategories();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: orderNotifier.orderList.isNotEmpty
            ? Container(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  backgroundColor: CollectionsColors.orange,
                  mini: false,
                  onPressed: () {
                    setState(() {
                      orderFinish = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(),
                        ));
                  },
                  child: Icon(
                    Icons.shopping_cart,
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget buildHorizontalListView() => ListView.separated(
        padding: EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => Divider(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
              categories[index],
              style: FontCollection.topicTextStyle,
            ),
          );
        },
      );

  Widget menuCategories() => BuildCard(
        headerText: items[index],
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: gridView(),
        ),
        canEdit: false,
      );

  Widget gridView() {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        controller: controller,
        itemCount: storeNotifier.menuList.length,
        itemBuilder: (context, index) {
          // final item = items[index];
          return menuData(storeNotifier, index);
        },
      ),
    );
  }

  // Widget catagoryCard() {}

  Widget menuData(StoreNotifier storeNotifier, int index) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    int amount = 0;
    bool isOrdered = false;

    if (orderNotifier.orderList != null) {
      for (int i = 0; i <= orderNotifier.orderList.length - 1; i++) {
        if (orderNotifier.orderList[i].menuName ==
            storeNotifier.menuList[index].name) {
          amount = orderNotifier.orderList[i].amount;
          isOrdered = true;
          // print(orderNotifier.orderList[i].menuName);
        }
      }
    }

    return Stack(
      children: [
        InkWell(
          onTap: () {
            storeNotifier.currentMenu = storeNotifier.menuList[index];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuDetail(
                      storeId: storeNotifier.currentStore.storeId,
                      menuId: storeNotifier.currentMenu.menuId),
                ));
          },
          child: Container(
            alignment: Alignment.centerLeft,
            width: 150,
            // color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Container(
                  height: 150,
                  margin: EdgeInsets.only(top: 15),
                  child: SizedBox(
                    child: Image.network(
                      storeNotifier.menuList[index].image != null
                          ? storeNotifier.menuList[index].image
                          : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                      // errorBuilder: (BuildContext context, Object exception,
                      //     StackTrace stackTrace) {
                      //   return Icon(Icons.image, size: 40.0);
                      // },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    storeNotifier.menuList[index].name,
                    textAlign: TextAlign.left,
                    style: //orderedMenu
                        (isOrdered)
                            ? TextStyle(
                                fontFamily: NotoSansFont,
                                fontWeight: FontWeight.w700,
                                fontSize: mediumSize,
                                color: CollectionsColors.orange,
                              )
                            : FontCollection.bodyTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    storeNotifier.menuList[index].price + ' บาท',
                    textAlign: TextAlign.left,
                    style: //orderedMenu
                        (isOrdered)
                            ? TextStyle(
                                fontFamily: NotoSansFont,
                                fontWeight: FontWeight.w700,
                                fontSize: regularSize,
                                color: CollectionsColors.orange,
                              )
                            : FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        (amount > 0)
            ? Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: CollectionsColors.navy),
                  child: Center(
                    child: AutoSizeText(
                      amount.toString(),
                      style: TextStyle(
                        fontFamily: NotoSansFont,
                        fontWeight: FontWeight.w700,
                        fontSize: regularSize,
                        color: CollectionsColors.white,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
