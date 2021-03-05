import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/screen/home.dart';
import 'package:aboutlx/screen/wrapper.dart';
import 'package:aboutlx/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Color.fromRGBO(240, 102, 74, 1),
          fontFamily: 'Mitr',
        ),
        home: Wrapper(),
      ),
    );
  }
}