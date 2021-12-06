import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';

class ShopRoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  ShopRoundedAppBar({
    Key key,
    this.appBarTitle,
    this.subTitle,
    this.leading,
    this.onClicked,
    this.child,
    this.automaticallyImplyLeading = true,
  })  : preferredSize =
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
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
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
              icon: Icon(Icons.info, color: Colors.black,),
            ),
          ],
        ),
      );
}

class ShopRoundedFavAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  ShopRoundedFavAppBar({
    Key key,
    this.appBarTitle,
    this.subTitle,
    this.onSaved,
    this.onClicked,
    this.isFavorite,
    this.child,
  })  : preferredSize = Size.fromHeight(160),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;
  final String subTitle;
  final VoidCallback onSaved;
  final VoidCallback onClicked;
  final bool isFavorite;
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
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
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
              padding: EdgeInsets.only(right: 0),
              icon: widget.isFavorite
                  ? Icon(Icons.bookmark, color: Colors.black,)
                  : Icon(Icons.bookmark_border_outlined, color: Colors.black,),
              onPressed: widget.onSaved,
            ),
            IconButton(
              onPressed: widget.onClicked,
              icon: Icon(Icons.info, color: Colors.black,),
            ),
          ],
        ),
      );
}
