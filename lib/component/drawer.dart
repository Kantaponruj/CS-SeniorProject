import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/screen/exhibitionMap.dart';
import 'package:aboutlx/screen/history.dart';
import 'package:aboutlx/screen/qrcodeScanner.dart';
import 'package:aboutlx/screen/schedule.dart';
import 'package:aboutlx/services/auth.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final AuthService _auth = AuthService();
  User user;
  DrawerMenu(this.user);

  Widget LoginAndOut(){
    if(user.isAnon){
      return ListTile(
        leading: Icon(Icons.power_settings_new),
        title: Text('Login with account'),
        onTap: () async {
          await _auth.logOut();

        },
      );
    }else{
      return ListTile(
        leading: Icon(Icons.power_settings_new),
        title: Text('Logout'),
        onTap: () async {
          await _auth.logOut();
//          await _auth.signInAnon();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Set the transparency here
        canvasColor: Colors.white.withOpacity(
            0.8), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://cdn4.iconfinder.com/data/icons/e-commerce-181/512/477_profile__avatar__man_-512.png")
                          )
                      )
                  ),
                  new Text(
                    user.isAnon ? "Guest":user.email,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.near_me),
              title: Text('Map'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ControllerPhotoViewPage()));
              },
            ),
//            ListTile(
//              leading: Icon(Icons.notifications),
//              title: Text('Notification'),
//              onTap: () {},
//            ),
            ListTile(
              leading: Icon(Icons.add_a_photo),
              title: Text('QR Code'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => qrcodeScanner()));
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Schedule'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => schedule(user: user,)));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => history(user: user,)));
              },
            ),
            LoginAndOut(),

          ],
        ),
      ),
    );
  }
}
