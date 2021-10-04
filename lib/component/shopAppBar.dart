import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/main.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:flutter/material.dart';

class ShopRoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  ShopRoundedAppBar(
      {Key key,
      this.appBarTitle,
      this.subTitle,
      this.leading,
      this.onClicked,
      this.child,this.automaticallyImplyLeading = true,})
      : preferredSize =
            child == null ? Size.fromHeight(80) : Size.fromHeight(140),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;
  final String subTitle;
  final Widget leading;
  final VoidCallback onClicked;
  final Widget child;
  final bool automaticallyImplyLeading;
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
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.subTitle == null
              ? Text(
                  widget.appBarTitle,
                  style: FontCollection.topicTextStyle,
                )
              : Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.appBarTitle,
                          style: FontCollection.topicTextStyle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.subTitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      )
                    ],
                  ),
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
            child: widget.child,
          ),
          // elevation: 10,
          // titleSpacing: 20,
          leading: widget.leading,
          actions: [
            IconButton(
              onPressed: widget.onClicked,
              icon: Icon(Icons.info),
            ),
          ],
        ),
      );
}

class ShopRoundedFavAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  ShopRoundedFavAppBar(
      {Key key,
      this.appBarTitle,
      this.subTitle,
      this.onClicked,
      this.onClicked2,
      this.child})
      : preferredSize = Size.fromHeight(160),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;
  final String subTitle;
  final VoidCallback onClicked;
  final VoidCallback onClicked2;
  final Widget child;
  double appbarHeight = 80.0;

  @override
  _ShopRoundedFavAppBarState createState() => _ShopRoundedFavAppBarState();
}

class _ShopRoundedFavAppBarState extends State<ShopRoundedFavAppBar> {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: AppBar(
          title: widget.subTitle == null
              ? Text(
                  widget.appBarTitle,
                  style: FontCollection.topicBoldTextStyle,
                )
              : Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.appBarTitle,
                          style: FontCollection.topicBoldTextStyle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.subTitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      )
                    ],
                  ),
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
            child: widget.child,
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
