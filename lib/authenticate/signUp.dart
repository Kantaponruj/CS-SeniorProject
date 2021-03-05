import 'package:aboutlx/component/loadingScreen.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme:
                  new IconThemeData(color: Color.fromRGBO(189, 189, 189, 1)),
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: EdgeInsets.only(
                                    left: 15.0,
                                    bottom: 8.0,
                                    top: 0.0,
                                    right: 15.0),
                                labelText: "E-mail",
                                helperText: 'Enter your user E-mail',
                                helperStyle: TextStyle(
                                    fontStyle: FontStyle.italic, height: 1),
                              ),
                              validator: (String value) {
                                if (!((value.contains('@')) &&
                                    (value.contains('.')))) {
                                  //validate email must contain '@' and '.'
                                  return 'Please enter your valid email';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: const EdgeInsets.only(
                                    left: 15.0, bottom: 8.0, top: 8.0),
                                labelText: "Password",
                                helperText:
                                    'Enter password with 8 or more characters',
                                helperStyle: TextStyle(
                                    // style of helpertext

                                    fontStyle: FontStyle.italic,
                                    height: 1),
                              ),
                              validator: (String value) {
                                if (value.length < 8) {
                                  // validate password must longer than 6 character
                                  return 'Password is too short must be at least 8 characters';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: const EdgeInsets.only(
                                    left: 15.0, bottom: 8.0, top: 8.0),
                                labelText: "Password confirm",
                                helperText: 'Re-type the password',
                                helperStyle: TextStyle(
                                    // style of helpertext

                                    fontStyle: FontStyle.italic,
                                    height: 1),
                              ),
                              validator: (String value) {
                                if (value != password) {
                                  // validate password must longer than 6 character
                                  return 'Password not match';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  loading = true;
                                  print("sign up with\n" +
                                      email +
                                      "\n" +
                                      password);
                                  dynamic result =
                                      await _auth.register(email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          "Invalid E-mail or It is already use";
                                    });
                                  } else {
                                    setState(() {
                                      error = "";
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: deviceData.size.width,
                                child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(240, 102, 74, 1),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        WhiteTitleText("Register"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SubTitleText(error),
                          ],
                        ),
                      ),
                    ],
                  )),
            ));
  }
}
