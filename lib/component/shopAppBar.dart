import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';

class ShopRoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  ShopRoundedAppBar({
    Key key,
    this.appBarTitle,
    this.onSaved,
    this.onClicked,
    this.isFavorite,
  })  : preferredSize = Size.fromHeight(80),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;
  final VoidCallback onSaved;
  final VoidCallback onClicked;
  final bool isFavorite;

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
          toolbarHeight: 100,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(30),
          //   ),
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
              padding: EdgeInsets.only(right: 0),
              icon: widget.isFavorite
                  ? Icon(Icons.book_online)
                  : Icon(Icons.bookmark_border_outlined),
              onPressed: widget.onSaved,
            ),
            IconButton(
              icon: Icon(Icons.info_outlined),
              onPressed: widget.onClicked,
            ),
          ],
        ),
      );
}
