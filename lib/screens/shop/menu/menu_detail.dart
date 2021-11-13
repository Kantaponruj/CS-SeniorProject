import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/widgets/bottomOrder_widget.dart';
import 'package:cs_senior_project/widgets/stepper.dart';
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
  int amount = 1;
  int totalPrice = 0;
  int priceMenu;
  double priceWithTopping;
  String price;
  List isSelectedTopping = [];
  List selectedTopping = [];
  List<Map<String, dynamic>> subToppingList = [];
  int totalSubTopping = 0;

  OrderModel order;

  TextEditingController otherController = new TextEditingController();

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
          break;
        } else {
          orderNotifier.currentOrder = null;
        }
      }
    } else {
      orderNotifier.currentOrder = null;
    }

    if (orderNotifier.currentOrder != null) {
      order = orderNotifier.currentOrder;
      price = order.totalPrice;
      amount = order.amount;
      priceWithTopping = double.parse(order.totalPrice) / amount;
      otherController.text = order.other;
    } else {
      order = OrderModel();
      price = storeNotifier.currentMenu.price;
    }

    priceMenu = int.parse(storeNotifier.currentMenu.price);

    super.initState();
  }

  void handleIncreaseAmount() {
    double priceTotal = double.parse(price);

    if (amount < 20) {
      amount += 1;

      if (selectedTopping.isNotEmpty)
        priceTotal += priceWithTopping;
      else
        priceTotal += priceMenu;
    }
    price = priceTotal.toInt().toString();
  }

  void handleDecreaseAmount() {
    double priceTotal = double.parse(price);

    if (amount > 0) {
      amount -= 1;

      if (selectedTopping.isNotEmpty) {
        priceTotal -= priceWithTopping;
      } else
        priceTotal -= priceMenu;
    }
    price = priceTotal.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    final double imgHeight = MediaQuery.of(context).size.height / 4;

    // for (int i = 0; i <= storeNotifier.toppingList.length - 1; i++) {
    //   for (int j = 0; j < storeNotifier.toppingList[i].subTopping.length; j++) {
    //     isSelectedTopping.add(false);
    //   }
    // }
    // print(isSelectedTopping);

    handleClick() {
      if (orderNotifier.currentOrder != null) {
        if (amount < 1) {
          orderNotifier.removeOrder(orderNotifier.currentOrder);
          orderNotifier.getNetPrice(0);
          orderNotifier.currentOrder = null;
        } else {
          order.totalPrice = price;
          order.topping = selectedTopping;
          order.amount = amount;
          order.other = otherController.text.trim();
        }

        // print('order length ' + orderNotifier.orderList.length.toString());
        // print(orderNotifier.orderList.map((data) => data.menuName));
        // print(orderNotifier.orderList.map((data) => data.totalPrice));
        // print(order.topping);
      } else {
        order.storeId = widget.storeId;
        order.menuId = widget.menuId;
        order.menuName = storeNotifier.currentMenu.name;
        order.totalPrice = price;
        order.topping = selectedTopping;
        order.amount = amount;
        order.other = otherController.text.trim();

        orderNotifier.addOrder(order);
        // print('order length ' + orderNotifier.orderList.length.toString());
        // print(orderNotifier.orderList.map((data) => data.menuName));
        // print(orderNotifier.orderList.map((data) => data.totalPrice));
      }

      for (int i = 0; i < orderNotifier.orderList.length; i++) {
        if (orderNotifier.orderList[i].storeId == widget.storeId) {
          totalPrice += int.parse(orderNotifier.orderList[i].totalPrice);
          orderNotifier.getNetPrice(totalPrice);
        }
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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: imgHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    child: Image.network(
                      storeNotifier.currentMenu.image != null
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
                        storeNotifier.toppingList.isEmpty
                            ? SizedBox.shrink()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: storeNotifier.toppingList.length,
                                itemBuilder: (context, index) {
                                  storeNotifier.toppingList[index].subTopping
                                      .forEach((element) {
                                    if (isSelectedTopping.length !=
                                        storeNotifier.toppingList[index]
                                            .subTopping.length) {
                                      isSelectedTopping.add(false);
                                    }
                                  });
                                  // print(isSelectedTopping);
                                  return moreCard(storeNotifier, index);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                controller: otherController,
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
              Container(
                margin: EdgeInsets.only(top: 20),
                child: CustomStepper(
                  iconSize: 30.0,
                  value: amount,
                  increaseAmount: handleIncreaseAmount,
                  decreaseAmount: handleDecreaseAmount,
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
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        storeNotifier.currentMenu.price,
                        style: FontCollection.topicBoldTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                'ราคาเริ่มต้น',
                style: FontCollection.smallBodyTextStyle,
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

  Widget moreCard(StoreNotifier storeNotifier, int index) {
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
              listAddOn(storeNotifier, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget listAddOn(StoreNotifier storeNotifier, int index) {
    double totalPriceInt = double.parse(price);

    if (order.topping != null) {
      selectedTopping = order.topping;

      for (int i = 0; i <= order.topping.length - 1; i++) {
        if (order.topping[i] ==
            storeNotifier.toppingList[index].subTopping[i]['name']) {
          isSelectedTopping[i] = true;
        }
      }
    }

    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: storeNotifier.toppingList[index].subTopping.length,
        itemBuilder: (context, i) {
          final subtopping = storeNotifier.toppingList[index].subTopping[i];

          return CheckboxListTile(
            title: Text(subtopping['name']),
            secondary: Text('+' + subtopping['price']),
            controlAffinity: ListTileControlAffinity.leading,
            value: isSelectedTopping[i],
            onChanged: (bool value) {
              setState(() {
                isSelectedTopping[i] = value;

                switch (isSelectedTopping[i]) {
                  case true:
                    if (amount > 1) {
                      totalPriceInt +=
                          (int.parse(subtopping['price']) * amount);
                      priceWithTopping = totalPriceInt;
                      priceWithTopping = priceWithTopping / amount;
                    } else {
                      totalPriceInt += int.parse(subtopping['price']);
                      priceWithTopping = totalPriceInt;
                    }
                    selectedTopping.insert(0, subtopping['name']);
                    break;
                  default:
                    if (amount > 1) {
                      totalPriceInt -=
                          (int.parse(subtopping['price']) * amount);
                      priceWithTopping = totalPriceInt;
                      priceWithTopping = priceWithTopping / amount;
                    } else {
                      totalPriceInt -= int.parse(subtopping['price']);
                      priceWithTopping = totalPriceInt;
                    }
                    selectedTopping.remove(subtopping['name']);
                }
                price = totalPriceInt.toInt().toString();
              });
            },
            activeColor: CollectionsColors.yellow,
            checkColor: CollectionsColors.white,
          );
        });
  }
}
