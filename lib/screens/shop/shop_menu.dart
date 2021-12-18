import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/favorite.dart';
import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/favorite_notifier.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/order/orderDetail.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/datetime_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShopMenu extends StatefulWidget {
  ShopMenu({Key key}) : super(key: key);

  @override
  _ShopMenuState createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  final controller = ScrollController();
  bool isShowBasket = false;
  String selectedAddress;

  Favorite _favorite = Favorite();
  bool _isFavorite = false;

  List menuList = [];
  List<MenuModel> _menuList = [];

  var address;

  @override
  void initState() {
    ActivitiesNotifier activity =
        Provider.of<ActivitiesNotifier>(context, listen: false);
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);
    FavoriteNotifier favorite =
        Provider.of<FavoriteNotifier>(context, listen: false);
    OrderNotifier order = Provider.of<OrderNotifier>(context, listen: false);
    LocationNotifier location =
        Provider.of<LocationNotifier>(context, listen: false);

    order.setPolylines(
      location,
      LatLng(
        store.currentStore.realtimeLocation.latitude,
        store.currentStore.realtimeLocation.longitude,
      ),
      store.currentStore.isDelivery,
      shippingPrice: int.parse(store.currentStore.shippingfee
          .substring(0, store.currentStore.shippingfee.length - 2)),
    );
    order.getNetPrice(
      store.currentStore.storeId,
      store.currentStore.isDelivery,
    );

    getMenu(store);

    if (favorite.favoriteList != null) {
      for (int i = 0; i < favorite.favoriteList.length; i++) {
        if (favorite.favoriteList[i].storeId == store.currentStore.storeId) {
          _isFavorite = true;
          break;
        }
      }
    }
    activity.resetDateTimeOrdered();
    getPlace(
      store.currentStore.realtimeLocation.latitude,
      store.currentStore.realtimeLocation.longitude,
    );
    super.initState();
  }

  _onSaveFavorite(Favorite favorite) {
    FavoriteNotifier favNotifier =
        Provider.of<FavoriteNotifier>(context, listen: false);
    favNotifier.addFavorite(favorite);
  }

  _onDeleteFavorite(Favorite favorite) {
    FavoriteNotifier favNotifier =
        Provider.of<FavoriteNotifier>(context, listen: false);
    favNotifier.deleteFavorite(favorite);
  }

  handleSaveFav(StoreNotifier store, UserNotifier user) {
    _isFavorite = !_isFavorite;
    _favorite.storeId = store.currentStore.storeId;
    saveFavoriteStore(
      _favorite,
      user.user.uid,
      _onSaveFavorite,
    );
  }

  handleDeleteFav(
    StoreNotifier store,
    UserNotifier user,
    FavoriteNotifier fav,
  ) {
    _isFavorite = !_isFavorite;
    for (int i = 0; i < fav.favoriteList.length; i++) {
      if (fav.favoriteList[i].storeId == store.currentStore.storeId) {
        deleteFavoriteStore(
          fav.favoriteList[i],
          _onDeleteFavorite,
          user.user.uid,
        );
      }
    }
  }

  String addressDetail = '';

  Future<void> getPlace(var latitude, var longitude) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      latitude,
      longitude,
    localeIdentifier: 'TH',);
    List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);

    Placemark placeMark = placemark[0];
    String name = placeMark.name;
    String street = placeMark.street;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String _address =
        "${street}, ${subLocality}, ${locality}, ${administrativeArea}";

    setState(() {
      addressDetail = _address;
      print(addressDetail);
    });
    // print(address);
  }


  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    FavoriteNotifier favNotifier = Provider.of<FavoriteNotifier>(context);

    if (orderNotifier.orderList.isNotEmpty) {
      for (int i = 0; i < orderNotifier.orderList.length; i++) {
        String orderStoreId = orderNotifier.orderList[i].storeId;
        String storeId = storeNotifier.currentStore.storeId;
        if (storeId == orderStoreId) isShowBasket = true;
      }
    }

    final appBarHeight = 135.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ShopRoundedFavAppBar(
        appBarTitle: storeNotifier.currentStore.storeName,
        subTitle: storeNotifier.currentStore.kindOfFood.join(', '),
        onClicked: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShopDetail(),
          ));
        },
        onSaved: () => _isFavorite
            ? handleDeleteFav(storeNotifier, userNotifier, favNotifier)
            : handleSaveFav(storeNotifier, userNotifier),
        isFavorite: _isFavorite,
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(40, 110, 0, 40),
          child: Row(
            children: [
              chipIconInfo(
                Icons.directions_car,
                '${orderNotifier.distance ?? ''} กม.',
                Color(0xFFC4C4C4),
                Colors.black,
                null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: chipInfo(
                  storeNotifier.currentStore.isDelivery ? 'จัดส่ง' : 'รับเอง',
                  storeNotifier.currentStore.isDelivery
                      ? CollectionsColors.yellow
                      : CollectionsColors.navy,
                  storeNotifier.currentStore.isDelivery
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: storeNotifier.currentStore.isDelivery
                    ? chipIconInfo(
                        Icons.attach_money,
                        '${orderNotifier.shippingFee} บาท',
                        Color(0xFF219653),
                        Colors.white,
                  null,
                      )
                    : chipIconInfo(
                        Icons.location_on,
                        addressDetail,
                        Colors.white,
                        Colors.black,
                  150,
                      ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: appBarHeight + 15),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              // snap: true,
              toolbarHeight: storeNotifier.currentStore.isDelivery ? 220 : 80,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: storeNotifier.currentStore.image != null
                          ? Image.network(
                              storeNotifier.currentStore.image,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Image.asset(
                                  'assets/images/default-photo.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                              },
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Image.asset(
                              'assets/images/default-photo.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                    storeNotifier.currentStore.isDelivery
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: orderTimeAndDate(),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
          body: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: storeNotifier.categoriesList.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              String category =
                                  storeNotifier.categoriesList[index];
                              return menuCategories(
                                  category, storeNotifier, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isShowBasket
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
                        builder: (context) => OrderDetailPage(
                          storeId: storeNotifier.currentStore.storeId,
                        ),
                      ));
                },
                child: Icon(
                  Icons.shopping_cart,
                ),
              ),
            )
          : Container(),
    );
  }

  Widget menuCategories(
    String categoryName,
    StoreNotifier storeNotifier,
    int indexC,
  ) {
    return BuildCard(
      headerText: categoryName,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: gridView(categoryName, storeNotifier, indexC),
      ),
      canEdit: false,
    );
  }

  Widget gridView(
    String categoryName,
    StoreNotifier storeNotifier,
    int indexC,
  ) {
    _menuList.clear();

    storeNotifier.menuList.forEach((menu) {
      if (menu.categoryFood == categoryName) {
        _menuList.add(menu);
      }
    });

    if (menuList.length != storeNotifier.categoriesList.length) {
      menuList.add(_menuList);
    }

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
        itemCount: menuList[indexC].length,
        itemBuilder: (context, index) {
          MenuModel menu = menuList[indexC][index];
          return menuData(storeNotifier, menu);
        },
      ),
    );
  }

  Widget menuData(StoreNotifier storeNotifier, MenuModel menu) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    int amount = 0;
    bool isOrdered = false;

    if (orderNotifier.orderList != null) {
      for (int i = 0; i <= orderNotifier.orderList.length - 1; i++) {
        if (orderNotifier.orderList[i].menuName == menu.name) {
          amount = orderNotifier.orderList[i].amount;
          isOrdered = true;
        }
      }
    }

    return Stack(
      children: [
        InkWell(
          onTap: () {
            storeNotifier.currentMenu = menu;
            storeNotifier.toppingList.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetail(
                    storeId: storeNotifier.currentStore.storeId,
                    menuId: storeNotifier.currentMenu.menuId),
              ),
            );
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
                    child: menu.image != null
                        ? Image.network(menu.image, fit: BoxFit.cover)
                        : Image.asset(
                            'assets/images/default-photo.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    menu.name,
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
                    menu.price + ' บาท',
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

  Widget orderTimeAndDate() {
    ActivitiesNotifier activity =
        Provider.of<ActivitiesNotifier>(context, listen: false);

    return Container(
      height: 130,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'การนัดหมาย/จัดส่ง',
                  style: FontCollection.bodyTextStyle,
                ),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Row(
                  children: [
                    Text(
                      activity.dateOrdered != null ? activity.dateOrdered : '',
                      style: FontCollection.bodyTextStyle,
                    ),
                    Text(
                      activity.startWaitingTime != null
                          ? '${activity.startWaitingTime} น.'
                          : 'ตอนนี้',
                      style: FontCollection.bodyTextStyle,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'จนถึง',
                              style: FontCollection.bodyTextStyle,
                            ),
                          ),
                          Text(
                            activity.endWaitingTime != null
                                ? '${activity.endWaitingTime} น.'
                                : 'กรุณาเลือกเวลา',
                            style: FontCollection.bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return editDeliTime();
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editDeliTime() {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'เวลาการรับ/จัดส่ง',
                        style: FontCollection.bodyTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                      child: DatePickerWidget(),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Column(
                        children: [
                          Row(children: [
                            TimePickerWidget(isStartWaitingTime: true),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'จนถึง',
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                          ]),
                          TimePickerWidget(isStartWaitingTime: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget meetingPlace() {
    AddressNotifier address = Provider.of<AddressNotifier>(context);
    LocationNotifier location = Provider.of<LocationNotifier>(context);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
      child: Row(
        children: [
          Icon(Icons.location_on),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: MediaQuery.of(context).size.width / 1.8,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
                value: selectedAddress,
                iconSize: 30,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: address.addressList
                    .map((value) => DropdownMenuItem(
                          value: value.addressName,
                          child: Text(
                            value.addressName ?? value.address,
                            style: FontCollection.bodyTextStyle,
                          ),
                        ))
                    .toList(),
                onChanged: (String value) {
                  setState(() {
                    selectedAddress = value;
                    address.addressList.forEach((element) {
                      if (value == element.addressName) {
                        location.setSelectedPosition(element);
                      }
                    });
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget chipInfo(
    String text,
    Color color,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(4, 4), // changes position of shadow
            ),
          ]),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }

  Widget chipIconInfo(
      IconData icon, String text, Color color, Color textColor, double size) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(4, 4), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: textColor,
          ),
          Container(
            width: size == null ? null : size,
            padding: const EdgeInsets.only(left: 5),
            child: AutoSizeText(
              text,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
