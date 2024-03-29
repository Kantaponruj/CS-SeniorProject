import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import '../main.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: MyApp(),
        title: Text(
          'Stalltruckr',
          style: FontCollection.topicBoldTextStyle,
        ),
        image: Image.asset('assets/images/stalltruckr_logo.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(color: CollectionsColors.orange),
        photoSize: 100.0,
        loaderColor: CollectionsColors.orange
    );
  }
}
