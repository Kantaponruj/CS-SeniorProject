import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/textformfield.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({Key key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    email.text = userNotifier.userModel.email;
    name.text = userNotifier.userModel.displayName;
    phone.text = userNotifier.userModel.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: RoundedAppBar(
        appBarTitle: 'แก้ไขข้อมูลส่วนตัว',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: storeSection(),
        ),
      ),
    );
  }

  Widget storeSection() {
    UserNotifier user = Provider.of<UserNotifier>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: buildTextField(
                'อีเมล',
                email,
                TextInputType.emailAddress,
                (value) {
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
                'กรุณากรอกอีเมล',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'รหัสผ่าน',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("โปรดตรวจสอบกล่องจดหมายในอีเมลของท่าน")));
                      user.resetPassword(user.userModel.email);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'เปลี่ยนรหัสผ่าน',
                        style: FontCollection.underlineButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: buildTextField(
                'ชื่อผู้ใช้',
                name,
                TextInputType.text,
                (value) {
                  if (value.isEmpty) {
                    return 'โปรดระบุชือ่ผู้ใช้';
                  }

                  return null;
                },
                'กรุณากรอกชื่อผู้ใช้',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: buildTextField(
                'เบอร์โทรศัพท์',
                phone,
                TextInputType.phone,
                (value) {
                  if (value.length != 10 || value[0] != '0') {
                    return 'โปรดระบุเบอร์โทรศัพท์ให้ถูกต้อง';
                  } else {
                    return null;
                  }
                },
                'กรุณากรอกเบอร์โทรศัพท์',
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: StadiumButtonWidget(
                text: 'บันทึก',
                onClicked: () {
                  user.updateUserData({
                    'email': email.text.trim(),
                    'displayName': name.text.trim(),
                    'phone': phone.text.trim(),
                  });
                  Navigator.pop(context);
                  user.reloadUserModel();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String headerText, TextEditingController controller,
      TextInputType keyboardType, Function(String) validator, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            headerText,
            style: FontCollection.bodyTextStyle,
          ),
        ),
        BuildPlainTextField(
          // initialValue: initialValue,
          keyboardType: keyboardType,
          textEditingController: controller,
          validator: validator,
          hintText: hintText,
          // onSaved: onSaved,
        ),
      ],
    );
  }
}
