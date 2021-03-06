import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/login.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<ScaffoldState>();
  // String username = '';
  // String email = '';
  String password = '';

  void login(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoginPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return Scaffold(
      key: formKey,
      body: authNotifier.status == Status.Authenticating
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text('Register'),
                      SizedBox(
                        height: 20,
                      ),
                      buildUsername(),
                      const SizedBox(
                        height: 30,
                      ),
                      buildEmail(),
                      const SizedBox(
                        height: 30,
                      ),
                      buildPassword(),
                      const SizedBox(
                        height: 30,
                      ),
                      buildConfirmPassword(),
                      const SizedBox(
                        height: 30,
                      ),
                      buildSubmit(),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        child: Text(
                          '?????????????????????????????????',
                          style: TextStyle(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () => login(context),
                        child: Text(
                          '?????????????????????????????????',
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildUsername() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return TextFormField(
      decoration: InputDecoration(
        labelText: '??????????????????????????????',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: authNotifier.displayName,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLength: 30,
      // onSaved: (value) => setState(() => username = value),
    );
  }

  Widget buildEmail() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return TextFormField(
      decoration: InputDecoration(
        labelText: '???????????????',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: authNotifier.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$)';
        final regExp = RegExp(pattern);

        if (value.isEmpty) {
          return '??????????????????????????????????????????';
        } else if (!regExp.hasMatch(value)) {
          return '????????????????????????????????????????????????????????????????????????';
        } else {
          return null;
        }
      },
      // onSaved: (value) => setState(() => email = value),
    );
  }

  Widget buildPassword() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return TextFormField(
      decoration: InputDecoration(
        labelText: '????????????????????????',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: authNotifier.password,
      validator: (value) {
        if (value.length < 8) {
          return '??????????????????????????????????????????????????????????????????????????????????????? 8 ';
        } else {
          return null;
        }
      },
      // onSaved: (value) => setState(() => password = value),
      obscureText: true,
    );
  }

  Widget buildConfirmPassword() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return TextFormField(
      decoration: InputDecoration(
        labelText: '??????????????????????????????????????????',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: authNotifier.confirmPassword,
      validator: (value) {
        if (value != authNotifier.password.text) {
          return '???????????????????????????????????????????????????';
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => password = value),
      obscureText: true,
    );
  }

  Widget buildSubmit() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return ButtonWidget(
      text: '???????????????????????????',
      onClicked: () async {
        if (!await authNotifier.signUp()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Register failed")));
          return;
        }
        authNotifier.clearController();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => bottomBar()),
            (route) => false);
        FocusScope.of(context).unfocus();
      },
    );
  }
}
