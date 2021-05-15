import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/user_notifier.dart';
import 'package:google_map_stores/screens/home.dart';
import 'package:google_map_stores/screens/login.dart';
import 'package:google_map_stores/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return Scaffold(
        key: _key,
        body: authNotifier.status == Status.Authenticating
            ? LoadingWidget()
            : SingleChildScrollView(
                child: Container(
                    constraints: BoxConstraints.expand(
                        height: MediaQuery.of(context).size.height),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(children: <Widget>[
                      Text(
                        "Please Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 36, color: Colors.black),
                      ),
                      SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "ชื่อผู้ใช้",
                          labelStyle: TextStyle(color: Colors.black12),
                        ),
                        controller: authNotifier.displayName,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 26, color: Colors.black),
                        cursorColor: Colors.black,
                        // validator: (String value) {
                        //   if (value.isEmpty) {
                        //     return 'Display Name is required';
                        //   }

                        //   if (value.length < 5 || value.length > 12) {
                        //     return 'Display Name must be betweem 5 and 12 characters';
                        //   }

                        //   return null;
                        // },
                      ),
                      TextFormField(
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
                        },
                      ),
                      TextFormField(
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
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "ยืนยันรหัสผ่าน",
                          labelStyle: TextStyle(color: Colors.black12),
                        ),
                        controller: authNotifier.password,
                        style: TextStyle(fontSize: 26, color: Colors.black),
                        cursorColor: Colors.black,
                        obscureText: true,
                        validator: (String value) {
                          if (value != authNotifier.password.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ButtonTheme(
                        minWidth: 200,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            child: Text("Regster"),
                            onPressed: () async {
                              if (!await authNotifier.signUp()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Register failed"),
                                  ),
                                );
                                return;
                              }
                              authNotifier.clearController();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
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
                              "Login here",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black54),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                          ),
                        ),
                      ),
                    ]))));
  }
}
