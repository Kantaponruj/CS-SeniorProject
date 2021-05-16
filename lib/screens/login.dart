import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/user_notifier.dart';
import 'package:google_map_stores/screens/home.dart';
import 'package:google_map_stores/screens/register.dart';
import 'package:google_map_stores/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<UserNotifier>(context);

    return Scaffold(
        key: _key,
        body: authNotifier.status == Status.Authenticating
            ? LoadingWidget()
            : Container(
                constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Please Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36, color: Colors.black),
                    ),
                    SizedBox(height: 32),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "อีเมล",
                              labelStyle: TextStyle(color: Colors.black12),
                            ),
                            controller: authNotifier.email,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 26, color: Colors.black),
                            cursorColor: Colors.black,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Email is required';
                              }

                              if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }

                              return null;
                            })),
                    SizedBox(height: 16),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "รหัสผ่าน",
                              labelStyle: TextStyle(color: Colors.black12),
                            ),
                            controller: authNotifier.password,
                            style: TextStyle(fontSize: 26, color: Colors.black),
                            cursorColor: Colors.black,
                            obscureText: true,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Password is required';
                              }

                              return null;
                            })),
                    SizedBox(height: 32),
                    ButtonTheme(
                      minWidth: 200,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          child: Text("Login"),
                          onPressed: () async {
                            if (!await authNotifier.signIn()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Login failed"),
                                ),
                              );
                              return;
                            }
                            authNotifier.clearController();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                (route) => false);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ButtonTheme(
                      minWidth: 200,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextButton(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              })),
                    ),
                  ],
                )));
  }
}
