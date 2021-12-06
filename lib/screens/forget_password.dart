import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/login.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                errorStyle: TextStyle(color: Colors.red),
              ),
              controller: authNotifier.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final pattern =
                    r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$)';
                final regExp = RegExp(pattern);

                if (value.isEmpty) {
                  return 'กรุณากรอกอีเมล';
                } else if (!regExp.hasMatch(value)) {
                  return 'กรุณากรอกอีเมลให้ถูกต้อง';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              text: 'ตั้งรหัสผ่านใหม่',
              width: 150,
              onClicked: () async {
                // final isValid = formKey.currentState.validate();
                // if (!await authNotifier.signIn()) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text("ส่งเข้าอีเมลเรียบร้อยแล้ว")));
                //   return;
                // }
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("ส่งเข้าอีเมลเรียบร้อยแล้ว")));
                authNotifier.resetPassword();
                authNotifier.clearController();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
