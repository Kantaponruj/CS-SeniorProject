import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/login.dart';
import 'package:cs_senior_project/screens/shop/menu/menu_detail.dart';
import 'package:cs_senior_project/screens/shop/shop_menu.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './component/bottomBar.dart';
import 'asset/text_style.dart';
import 'notifiers/store_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserNotifier.initialize()),
        ChangeNotifierProvider(create: (context) => StoreNotifier()),
        ChangeNotifierProvider(create: (context) => AddressNotifier()),
        ChangeNotifierProvider(create: (context) => LocationNotifier())
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: NotoSansFont,
          primaryColor: CollectionsColors.orange,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: CollectionsColors.grey,
          buttonColor: CollectionsColors.yellow,
        ),
        home: MyApp(),
        // initialRoute: '/',
        routes: {
          '/shopMenu': (context) => ShopMenu(),
          '/menuDetail': (context) => MenuDetail(),
        },
      )));
}

class MyApp extends StatelessWidget {
  // static final String title = 'Home';
  // This widget is the root of your application.
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
                return LoginPage();
              case Status.Authenticated:
                return bottomBar();
              default:
                return LoginPage();
            }
          }

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
        });
  }
}
