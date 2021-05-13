import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/auth_notifier.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/screens/selectMap.dart';
import 'package:google_map_stores/services/auth_service.dart';
import 'package:google_map_stores/services/store_service.dart';
import 'package:google_map_stores/widgets/mapWidget.dart';
import 'package:google_map_stores/widgets/storeListWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(authNotifier.user != null
              ? authNotifier.user.displayName
              : "Welcome"),
          actions: <Widget>[
            TextButton(
                onPressed: () => signout(authNotifier),
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
