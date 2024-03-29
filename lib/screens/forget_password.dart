import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/textformfield.dart';
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
      appBar: RoundedAppBar(
        appBarTitle: 'ตั้งรหัสผ่านใหม่',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BuildPlainCard(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'กรุณากรอกอีเมลเพื่อส่งลิงก์เพื่อตั้งค่ารหัสใหม่',
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
                BuildTextField(
                  hintText: 'test@mail.com',
                  labelText: 'อีเมล',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: authNotifier.email,
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
                Container(
                  padding: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ButtonWidget(
                    text: 'ยืนยัน',
                    onClicked: () async {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("โปรดตรวจสอบกล่องจดหมายในอีเมลของท่าน")));
                      authNotifier
                          .resetPassword(authNotifier.email.text.trim());
                      authNotifier.clearController();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
