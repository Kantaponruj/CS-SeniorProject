import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../component/bottomBar.dart';

class HomePage extends StatelessWidget {

  static const routeName = '/homepage';

  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('This is home page'),
          ],
        )
      ),
    );
  }
}
