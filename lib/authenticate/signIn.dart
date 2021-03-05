import 'package:aboutlx/authenticate/signUp.dart';
import 'package:aboutlx/component/loadingScreen.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30),
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
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'E-mail is a required filed.';
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
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                // validate password must longer than 6 character
                                return 'Password is a required filed.';
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
                          SizedBox(height: 30),
                          SubTitleText(error),
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                print(
                                    "sign up with\n" + email + "\n" + password);
                                dynamic result =
                                    await _auth.signIn(email, password);
                                if (result == null) {
                                  setState(() {
                                    error = "E-mail and password are not match";
                                    loading = false;
                                  });
                                } else {
                                  setState(() {
                                    error = "";
//                                  Navigator.of(context).pop();
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      WhiteTitleText("Log in"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(children: <Widget>[
                            Expanded(
                                child: Divider(
                              thickness: 1,
                              color: Colors.black,
                              endIndent: 5,
                            )),
                            Text("OR"),
                            Expanded(
                                child: Divider(
                              thickness: 1,
                              color: Colors.black,
                              indent: 5,
                            )),
                          ]),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              MaterialPageRoute signUpRoute = MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp());
                              Navigator.of(context).push(signUpRoute);
                            },
                            child: Container(
                              width: deviceData.size.width,
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color.fromRGBO(240, 102, 74, 0.3),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TitleText("Create New Account"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                loading = true;
                              });
                              print(loading);
                              _auth.signInAnon();
                            },
                            child: Container(
                              width: deviceData.size.width,
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color.fromRGBO(189, 189, 189, 1),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      WhiteTitleText("Log in as Guest"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
          );
  }
}
