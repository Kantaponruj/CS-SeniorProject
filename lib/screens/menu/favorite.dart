import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'บันทึก',
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return listCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          leading: Container(
            child: CircleAvatar(
              backgroundColor: CollectionsColors.yellow,
              radius: 40.0,
              // child: Text(
              //   nameUpperCase,
              //   style: FontCollection.topicBoldTextStyle,
              //   textAlign: TextAlign.left,
              // ),
              backgroundImage: AssetImage(
                'assets/images/shop_test.jpg',
              ),
            ),
          ),
          title: Text(
            'โตเกียวหน้าม.',
            style: FontCollection.bodyTextStyle,
          ),
          subtitle: Container(
            alignment: Alignment.centerLeft,
              child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'ของหวาน',
                  style: FontCollection.smallBodyTextStyle,
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: CollectionsColors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                    child: Text(
                      'รับเอง',
                      style: FontCollection.descriptionTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          )),
          onTap: () {},
        ),
      ),
    );
  }
}
