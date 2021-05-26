import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_stores/helper/constant.dart';
import 'package:google_map_stores/notifiers/location_notifier.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/notifiers/user_notifier.dart';
import 'package:google_map_stores/screens/home.dart';
import 'package:google_map_stores/screens/login.dart';
import 'package:google_map_stores/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

import './screens/Home_page.dart';
import './asset/colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StoreNotifier()),
        ChangeNotifierProvider(create: (context) => LocationNotifier()),
        ChangeNotifierProvider.value(value: UserNotifier.initialize())
        // ChangeNotifierProvider(create: (context) => UserNotifier.initialize())
      ],
      // child: MyApp(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        title: "Flutter",
        home: MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserNotifier auth = Provider.of<UserNotifier>(context);

    return FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Something went wrong")],
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            switch (auth.status) {
              case Status.Uninitialized:
                return LoadingWidget();
              case Status.Unauthenticated:
              case Status.Authenticating:
                return Login();
              case Status.Authenticated:
                return Home();
              default:
                return Login();
            }
          }

          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ));
        });
  }
}
