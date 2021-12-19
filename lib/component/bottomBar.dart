import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/screens/history.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:cs_senior_project/screens/menu.dart';
import 'package:cs_senior_project/screens/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomBar extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<BottomBar> {
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
      backgroundColor: CollectionsColors.orange,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _menuBar,
        currentIndex: _selectedIndex,
        backgroundColor: CollectionsColors.orange,
        selectedItemColor: Colors.white,
        unselectedItemColor: CollectionsColors.grey.withOpacity(0.4),
        onTap: _onItemTapped,
      ),
    );
  }
}
