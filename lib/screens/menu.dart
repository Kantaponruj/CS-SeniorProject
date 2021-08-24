import 'dart:async';

import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'address/address.dart';

class MenuPage extends StatefulWidget {
  static const routeName = '/menu';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 6,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: CollectionsColors.yellow,
                          radius: 30.0,
                          child: Text(
                            userNotifier.userModel.displayName,
                            style: FontCollection.descriptionTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        title: Text(
                          userNotifier.userModel.displayName,
                          style: FontCollection.topicTextStyle,
                        ),
                        subtitle: Text(
                          'แก้ไข',
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              menuCard(
                Icons.bookmark_border,
                'บันทึก',
                () {},
              ),
              menuCard(
                Icons.calendar_today,
                'การนัดหมาย',
                () {},
              ),
              menuCard(
                Icons.place,
                'ที่อยู่',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Address(uid: userNotifier.userModel.uid)));
                },
              ),
              menuCard(
                Icons.exit_to_app,
                'ออกจากระบบ',
                () {
                  userNotifier.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard(IconData icons, String text, VoidCallback onClicked) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: InkWell(
        onTap: onClicked,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              leading: Icon(
                icons,
                color: Colors.black,
              ),
              title: Text(
                text,
                style: FontCollection.topicTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
