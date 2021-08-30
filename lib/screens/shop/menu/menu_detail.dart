import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDetail extends StatefulWidget {
  MenuDetail({Key key, this.storeId, this.menuId}) : super(key: key);
  final String storeId;
  final String menuId;

  static const routeName = '/history';

  @override
  _MenuDetailState createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  String price;
  List isSelectedTopping = [];
  List selectedTopping = [];

  OrderModel order;

  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getTopping(storeNotifier, widget.storeId, widget.menuId);

    if (orderNotifier.orderList != null) {
      for (int i = 0; i <= orderNotifier.orderList.length - 1; i++) {
        if (orderNotifier.orderList[i].menuName ==
            storeNotifier.currentMenu.name) {
          orderNotifier.currentOrder = orderNotifier.orderList[i];
          // print('this current menu: ' + orderNotifier.currentOrder.menuId);
          // print(i);
          break;
        } else {
          orderNotifier.currentOrder = null;
          // print('new menu in list');
          // print(i);
        }
      }
    }

    if (orderNotifier.currentOrder != null) {
      order = orderNotifier.currentOrder;
      price = order.totalPrice;
    } else {
      order = OrderModel();
      price = storeNotifier.currentMenu.price;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    final double imgHeight = MediaQuery.of(context).size.height / 4;

    for (int i = 0; i <= storeNotifier.toppingList.length - 1; i++) {
      isSelectedTopping.add(false);
    }

    handleClick() {
      if (orderNotifier.currentOrder != null) {
        order.totalPrice = price;
        order.topping = selectedTopping;

        print('order length ' + orderNotifier.orderList.length.toString());
        print(orderNotifier.orderList.map((data) => data.menuName));
        print(orderNotifier.orderList.map((data) => data.totalPrice));
        print(order.topping);
      } else {
        order.menuId = widget.menuId;
        order.menuName = storeNotifier.currentMenu.name;
        order.totalPrice = price;
        order.topping = selectedTopping;

        orderNotifier.addOrder(order);
        print('order length ' + orderNotifier.orderList.length.toString());
        print(orderNotifier.orderList.map((data) => data.menuName));
        print(orderNotifier.orderList.map((data) => data.totalPrice));
      }

      orderedMenu = true;
      Navigator.of(context).pop();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          child: Stack(
            children: [
              Container(
                height: imgHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  child: Image.network(
                    storeNotifier.currentMenu.image.isNotEmpty
                        ? storeNotifier.currentMenu.image
                        : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, imgHeight - 30, 20, 30),
                  child: Column(
                    children: [
                      menuDetailCard(storeNotifier),
                      moreCard(storeNotifier),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // SearchWidget(),
        ),
        bottomNavigationBar: BottomOrder(
          price: price,
          onClicked: handleClick,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'ข้อความเพิ่มเติม',
                  style: FontCollection.bodyTextStyle,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  // errorText: 'Error message',
                  hintText: 'ใส่ข้อความตรงนี้',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // suffixIcon: Icon(
                  //   Icons.error,
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuDetailCard(StoreNotifier storeNotifier) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: CollectionsColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    storeNotifier.currentMenu.name,
                    style: FontCollection.topicTextStyle,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              storeNotifier.currentMenu.price,
                              style: FontCollection.topicTextStyle,
                            )),
                        Text(
                          'ราคาเริ่มต้น',
                          style: FontCollection.smallBodyTextStyle,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  storeNotifier.currentMenu.description,
                  style: FontCollection.bodyTextStyle,
                )),
          ],
        ),
      ),
    );
  }

  Widget moreCard(StoreNotifier storeNotifier) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      'เพิ่มเติม',
                      style: FontCollection.bodyBoldTextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'เลือกได้สูงสุด 2 อย่าง',
                        style: FontCollection.descriptionTextStyle,
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: storeNotifier.toppingList.length,
                itemBuilder: (context, index) {
                  return listAddOn(storeNotifier, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listAddOn(StoreNotifier storeNotifier, int index) {
    int totalPriceInt = int.parse(price);
    int toppingPriceInt = int.parse(storeNotifier.toppingList[index].price);

    if (order.topping != null) {
      selectedTopping = order.topping;

      for (int i = 0; i <= order.topping.length - 1; i++) {
        if (order.topping[i] == storeNotifier.toppingList[index].name) {
          isSelectedTopping[index] = true;
        }
      }
    }

    return CheckboxListTile(
      title: Text(storeNotifier.toppingList[index].name),
      secondary: Text('+' + storeNotifier.toppingList[index].price),
      controlAffinity: ListTileControlAffinity.leading,
      value: isSelectedTopping[index],
      onChanged: (bool value) {
        setState(() {
          isSelectedTopping[index] = value;

          switch (isSelectedTopping[index]) {
            case true:
              totalPriceInt += toppingPriceInt;
              selectedTopping.insert(0, storeNotifier.toppingList[index].name);
              break;
            default:
              totalPriceInt -= toppingPriceInt;
              selectedTopping.remove(storeNotifier.toppingList[index].name);
          }
          price = totalPriceInt.toString();
        });
      },
      activeColor: CollectionsColors.yellow,
      checkColor: CollectionsColors.white,
    );
  }
}
