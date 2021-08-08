import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopMenu extends StatefulWidget {
  @override
  _ShopMenuState createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  int index = 0;
  final items = List.generate(10, (counter) => 'Item: $counter');
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: ShopRoundedAppBar(
          appBarTitle: storeNotifier.currentStore.storeName,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(top: 80),
                  child: Expanded(
                    child: Image.asset(
                      'assets/images/shop_test.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: buildHorizontalListView(),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  child: gridView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHorizontalListView() => ListView.separated(
        padding: EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => Divider(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
              item,
              style: FontCollection.topicTextStyle,
            ),
          );
        },
      );

  Widget menuCategories() => ExpansionTile(
        childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
        title: Text(
          items[index],
          style: FontCollection.topicTextStyle,
        ),
        children: [
          gridView(),
        ],
      );

  Widget gridView() => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 30,
        ),
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        controller: controller,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return buildNumber(item);
        },
      );

  Widget buildNumber(String number) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetail(),
              ));
        },
        child: Container(
          alignment: Alignment.centerLeft,
          color: Theme.of(context).primaryColor,
          child: GridTile(
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: SizedBox(
                    child: Image.asset(
                      'assets/images/shop_test.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Menu name',
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Price 22',
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
