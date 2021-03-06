import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/home.dart';
import 'package:cs_senior_project/screens/register.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<ScaffoldState>();
  // String email = '';
  // String password = '';

  void register(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return RegisterPage();
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
                        height: 150,
                      ),
                      buildEmail(),
                      const SizedBox(
                        height: 30,
                      ),
                      buildPassword(),
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
                        onTap: () => register(context),
                        child: Text(
                          '???????????????????????????',
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
        if (value.isEmpty) {
          return '????????????????????????????????????????????????';
        }
        return null;
      },
      // onSaved: (value) => setState(() => password = value),
      obscureText: true,
    );
  }

  Widget buildSubmit() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return ButtonWidget(
      text: '?????????????????????????????????',
      onClicked: () async {
        // final isValid = formKey.currentState.validate();
        if (!await authNotifier.signIn()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login failed")));
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
