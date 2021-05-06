import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/auth_notifier.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/screens/auth.dart';
import 'package:google_map_stores/screens/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthNotifier()),
      // ChangeNotifierProvider(create: (context) => StoreNotifier())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthNotifier>(
          builder: (context, notifier, child) {
            return notifier.user != null ? Home() : Auth();
          },
        ));
  }
}
