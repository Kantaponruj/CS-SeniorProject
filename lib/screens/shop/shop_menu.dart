import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/order/orderDetail.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:cs_senior_project/screens/shop/shop_detail.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/widgets/datetime_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopMenu extends StatefulWidget {
  ShopMenu({Key key, this.storeIndex}) : super(key: key);
  final int storeIndex;

  @override
  _ShopMenuState createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  int index = 0;
  final items = List.generate(10, (counter) => 'Item: $counter');
  final controller = ScrollController();
  bool isShowBasket = false;

  List categories = [];

  @override
  void initState() {
    ActivitiesNotifier activity =
        Provider.of<ActivitiesNotifier>(context, listen: false);
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);

    getMenu(storeNotifier);
    activity.resetDateTimeOrdered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    if (orderNotifier.orderList.isNotEmpty) {
      for (int i = 0; i < orderNotifier.orderList.length; i++) {
        String orderStoreId = orderNotifier.orderList[i].storeId;
        String storeId = storeNotifier.currentStore.storeId;
        if (storeId == orderStoreId) isShowBasket = true;
      }
    }

    categories.clear();
    storeNotifier.menuList.forEach((menu) {
      if (categories.contains(menu.categoryFood)) {
      } else {
        categories.add(menu.categoryFood);
      }
    });

    final appBarHeight = 135.0;

    // print(categories);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ShopRoundedFavAppBar(
        appBarTitle: storeNotifier.currentStore.storeName,
        subTitle: 'ของหวาน',
        onClicked2: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShopDetail(),
          ));
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          // margin: EdgeInsets.only(top: appBarHeight),
          padding: EdgeInsets.fromLTRB(70, 110, 0, 30),
          child: Row(
            children: [
              chipIconInfo(
                Icons.directions_car,
                '0.2 กม.',
                Color(0xFFC4C4C4),
                Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: chipInfo('จัดส่ง'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: chipIconInfo(
                  Icons.attach_money,
                  '10 บาท',
                  Color(0xFF219653),
                  Colors.white,
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
              toolbarHeight: 220,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: orderTimeAndDate(),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                // Container(
                //   height: 80,
                //   padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                //   child: buildHorizontalListView(),
                // ),
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

  Widget buildHorizontalListView() => ListView.builder(
        padding: EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        // separatorBuilder: (context, index) => Divider(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
              categories[index],
              style: FontCollection.topicBoldTextStyle,
            ),
          );
        },
      );

  Widget menuCategories() => BuildCard(
        headerText: categories[index],
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
                title: Text(
                  (activity.dateOrdered != null && activity.timeOrdered != null)
                      ? '${activity.dateOrdered} ${activity.timeOrdered} น.'
                      : 'now',
                  style: FontCollection.bodyTextStyle,
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
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DatePickerWidget(),
                          TimePickerWidget(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'สถานที่การรับ/จัดส่งสินค้า',
                        style: FontCollection.bodyTextStyle,
                      ),
                    ),
                    meetingPlace(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String value;

  Widget meetingPlace() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        children: [
          Icon(Icons.location_on),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: MediaQuery.of(context).size.width / 1.6,
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
            child: DropdownButton<String>(
                value: value,
                iconSize: 30,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: items.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() => this.value = value)),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: FontCollection.bodyTextStyle,
        ),
      );

  Widget chipInfo(
    String text,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: CollectionsColors.yellow,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(4, 4), // changes position of shadow
            ),
          ]
      ),
      child: Text(
        text,
        style: FontCollection.descriptionTextStyle,
      ),
    );
  }

  Widget chipIconInfo(IconData icon, String text, Color color, Color textColor) {
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
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20,color: textColor,),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
