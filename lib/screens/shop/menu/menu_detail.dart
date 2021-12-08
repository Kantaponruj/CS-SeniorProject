import 'package:cs_senior_project/asset/color.dart';
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

  // List<Map<String, dynamic>> subToppingList = [];
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

    if (orderNotifier.orderList.isNotEmpty) {
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

  void handleClick() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);

    if (orderNotifier.currentOrder != null) {
      if (amount < 1) {
        orderNotifier.removeOrder(orderNotifier.currentOrder);
        orderNotifier.currentOrder = null;
      } else {
        order.totalPrice = price;
        order.topping = selectedTopping;
        order.amount = amount;
        order.other = otherController.text.trim();
      }
    } else {
      order.storeId = widget.storeId;
      order.menuId = widget.menuId;
      order.menuName = storeNotifier.currentMenu.name;
      order.totalPrice = price;
      order.topping = selectedTopping;
      order.amount = amount;
      order.other = otherController.text.trim();

      orderNotifier.addOrder(order);
    }

    orderNotifier.getNetPrice(
      storeNotifier.currentStore.storeId,
      storeNotifier.currentStore.isDelivery,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    final double imgHeight = MediaQuery.of(context).size.height / 4;

    // getTopping(storeNotifier, widget.storeId, widget.menuId);

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
                    child: storeNotifier.currentMenu.image != null
                        ? Image.network(
                            storeNotifier.currentMenu.image,
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
                ),
                Positioned(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, imgHeight - 30, 20, 30),
                    child: Column(
                      children: [
                        menuDetailCard(storeNotifier),
                        storeNotifier.toppingList == null
                            ? SizedBox.shrink()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: storeNotifier.toppingList.length,
                                itemBuilder: (context, index) {
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CollectionsColors.white,
      ),
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
    );
  }

  List defaultSelected = [];

  Widget moreCard(StoreNotifier storeNotifier, int indexT) {
    // defaultSelected.clear();
    if (storeNotifier.toppingList.length > 1) {
      defaultSelected.clear();
    }

    storeNotifier.toppingList[indexT].subTopping.forEach(
      (element) {
        defaultSelected.add(false);
      },
    );

    if (isSelectedTopping.length != storeNotifier.toppingList.length) {
      isSelectedTopping.add(defaultSelected);
      // isSelectedTopping.sort((a, b) => a.length.compareTo(b.length));
    }
    // print(isSelectedTopping);

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
                        'เลือกได้สูงสุด ${storeNotifier.toppingList[indexT].selectedNumberTopping} อย่าง',
                        style: FontCollection.descriptionTextStyle,
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              listAddOn(storeNotifier, indexT),
            ],
          ),
        ),
      ),
    );
  }

  Widget listAddOn(StoreNotifier storeNotifier, int indexT) {
    double totalPriceInt = double.parse(price);

    if (order.topping != null) {
      selectedTopping = order.topping;

      for (int i = 0; i < order.topping.length; i++) {
        for (int j = 0;
            j < storeNotifier.toppingList[indexT].subTopping.length;
            j++) {
          if (order.topping[i] ==
              storeNotifier.toppingList[indexT].subTopping[j]['name']) {
            isSelectedTopping[indexT][j] = true;
          }
        }
      }
    }
    int val = 0;

    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: storeNotifier.toppingList[indexT].subTopping.length,
        itemBuilder: (context, i) {
          final subtopping = storeNotifier.toppingList[indexT].subTopping[i];

          return storeNotifier.toppingList[indexT].type == 'ตัวเลือกเดียว'
              ? Container(
                  color: Colors.white,
                  child: RadioListTile(
                    title: Text(subtopping['name']),
                    secondary: Text('+' + subtopping['price']),
                    value: 0,
                    // groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value;
                      });
                    },
                    activeColor: CollectionsColors.yellow,
                    tileColor: CollectionsColors.white,
                    selectedTileColor: CollectionsColors.white,
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: CheckboxListTile(
                    title: Text(subtopping['name']),
                    secondary: Text('+' + subtopping['price']),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: isSelectedTopping[indexT][i],
                    onChanged: (bool value) {
                      // isSelectedTopping[indexT][i] = !isSelectedTopping[indexT][i];
                      // print(i);
                      // print(isSelectedTopping[indexT]);

                      setState(() {
                        isSelectedTopping[indexT][i] = value;

                        switch (isSelectedTopping[indexT][i]) {
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
                            selectedTopping.add(subtopping['name']);
                            // print(selectedTopping);
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
                  ),
                );
        });
  }
}
