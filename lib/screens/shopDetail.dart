import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:flutter/material.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({Key key}) : super(key: key);

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShopRoundedAppBar(),
      body: Container(
        
      ),
    );
  }
}
