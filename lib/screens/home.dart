import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/notifiers/user_notifier.dart';
import 'package:google_map_stores/screens/login.dart';
import 'package:google_map_stores/screens/selectMap.dart';
import 'package:google_map_stores/services/store_service.dart';
import 'package:google_map_stores/widgets/mapWidget.dart';
import 'package:google_map_stores/widgets/storeListWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/bottomBar.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getStores(storeNotifier);
    // _deviceToken();
    super.initState();
  }

  // _deviceToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   UserNotifier _user = Provider.of<UserNotifier>(context, listen: false);

  //   if (_user.userModel.token != preferences.getString('token')) {
  //     Provider.of<UserNotifier>(context, listen: false).saveDeviceToken();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(userNotifier.userModel?.displayName ?? ""),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  userNotifier.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))
          ],
        ),
        body: Container(
            child: Column(children: [
          Flexible(flex: 2, child: MapWidget(mapController: _mapController)),
          SizedBox(height: 12),
          Flexible(
              flex: 2, child: StoreListWidget(mapController: _mapController)),
          SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectMap()));
            },
            label: Text('Get Current Location'),
            icon: Icon(Icons.directions_boat),
          )
        ])));
  }
}
