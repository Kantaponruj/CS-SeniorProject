import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/screens/history.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:cs_senior_project/screens/login.dart';
import 'package:cs_senior_project/screens/menu.dart';
import 'package:cs_senior_project/screens/notification.dart';
import 'package:cs_senior_project/screens/shop/shop_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class bottomBar extends StatefulWidget {
  // static const routeName = '/';

  @override
  _State createState() => _State();
}

class _State extends State<bottomBar> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    HomePage(),
    NotificationsPage(),
    // ShopMenu(),
    HistoryPage(),
    MenuPage(),
  ];
  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.notifications),
      title: Text('Notification'),
    ),
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.history),
      title: Text('History'),
    ),
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.menu),
      title: Text('Menu'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: CollectionsColors.orange,
        unselectedItemColor: CollectionsColors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
