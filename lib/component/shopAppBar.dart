import 'package:cs_senior_project/main.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:flutter/material.dart';

class ShopRoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  ShopRoundedAppBar({Key key, this.appBarTitle})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;


  @override
  _ShopRoundedAppBarState createState() => _ShopRoundedAppBarState();
}

class _ShopRoundedAppBarState extends State<ShopRoundedAppBar> {

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //     borderRadius: BorderRadius.vertical(
        //       bottom: Radius.circular(30),
        //     ),
        //   ),
        ),
        elevation: 10,
        titleSpacing: 20,
        actions: [
          IconButton(icon: Icon(Icons.info_outlined),onPressed: () {},),
        ],
      )
  );
}
