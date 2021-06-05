import 'dart:async';

import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Menu extends StatefulWidget {
  static const routeName = '/menu';

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Widget> _children;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: RoundedAppBar(appBarTitle: 'Menu',),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is menu page'),
            // SearchWidget(),
          ],
        ),
      ),
    );
  }
}
