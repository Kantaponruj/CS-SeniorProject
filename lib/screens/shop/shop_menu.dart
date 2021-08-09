import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopMenu extends StatefulWidget {
  ShopMenu({Key key, this.storeId}) : super(key: key);
  final String storeId;

  @override
  _ShopMenuState createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  int index = 0;
  final items = List.generate(10, (counter) => 'Item: $counter');
  final controller = ScrollController();

  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getMenu(storeNotifier, widget.storeId);
    super.initState();
  }

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
                    ]),
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

  Widget gridView() {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 30,
      ),
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      controller: controller,
      itemCount: storeNotifier.menuList.length,
      itemBuilder: (context, index) {
        // final item = items[index];
        return InkWell(
          onTap: () {
            storeNotifier.currentMenu = storeNotifier.menuList[index];
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
                  Expanded(
                    flex: 2,
                    child: Text(
                      storeNotifier.menuList[index].name,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      storeNotifier.menuList[index].price + ' บาท',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
