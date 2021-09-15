import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/main.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:flutter/material.dart';

class ShopRoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  ShopRoundedAppBar(
      {Key key, this.appBarTitle, this.onClicked, this.onClicked2})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;
  final VoidCallback onClicked;
  final VoidCallback onClicked2;
  double appbarHeight = 80.0;

  @override
  _ShopRoundedAppBarState createState() => _ShopRoundedAppBarState();
}

class _ShopRoundedAppBarState extends State<ShopRoundedAppBar> {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: AppBar(
          title: Text(
            widget.appBarTitle,
            style: FontCollection.topicTextStyle,
          ),
          toolbarHeight: widget.appbarHeight,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // elevation: 10,
          // titleSpacing: 20,
          actions: [
            IconButton(
              onPressed: widget.onClicked,
              icon: Icon(Icons.bookmark),
            ),
            IconButton(
              onPressed: widget.onClicked2,
              icon: Icon(Icons.info),
            ),
          ],
        ),
      );
}
