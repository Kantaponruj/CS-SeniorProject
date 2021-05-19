import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../screens/home.dart';
import '../asset/colors.dart';


class BottomBar extends StatefulWidget {
  BottomBar({Key key, this.uid}) : super(key: key);
  final String uid;

  static const routeName = '/';

  @override
  _BottomBarState createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  var tabs;
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
    tabs = [
      Container(child: Home()),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(MaterialIcons.home),
              // title: Text('หน้าหลัก'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              // title: Text('การแจ้งเตือน'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialIcons.history),
              // title: Text('ประวัติ'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialIcons.account_circle),
              // title: Text('โปรไฟล์'),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: CollectionColors.gray(),
          // items: _menuBar,
          currentIndex: _selectedIndex,
          unselectedItemColor: CollectionColors.gray(),
          selectedItemColor: CollectionColors.orange(),
          onTap: _onItemTapped),
    );
  }
}