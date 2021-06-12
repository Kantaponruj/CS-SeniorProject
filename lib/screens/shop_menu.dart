import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:flutter/material.dart';

class ShopMenu extends StatefulWidget {
  @override
  _ShopMenuState createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ShopRoundedAppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/cycling_1.jpg',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(

              ),
            ),
          ],
        ),
      ),
    );
  }
}
