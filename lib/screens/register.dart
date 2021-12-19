import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/component/textformfield.dart';
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(
          'ลงทะเบียน',
          style: FontCollection.topicBoldTextStyle,
        ),
        backgroundColor: CollectionsColors.grey,
        elevation: 0,
        toolbarHeight: 80,
      ),
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
                        height: 20,
                      ),
                      buildUsername(authNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildEmail(authNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildPassword(authNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildConfirmPassword(authNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildPhoneNumber(authNotifier),
                      const SizedBox(
                        height: 50,
                      ),
                      buildSubmit(authNotifier),
                      const SizedBox(
                        height: 15,
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
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'หากคุณมีบัญชีแล้ว ',
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            InkWell(
                              onTap: () => login(context),
                              child: Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildUsername(UserNotifier authNotifier) {
    return BuildTextField(
      hintText: 'กรุณากรอกชื่อผู้ใช้',
      labelText: 'ชื่อผู้ใช้',
      textInputType: TextInputType.text,
      textEditingController: authNotifier.displayName,
      validator: (value) {
        if (value.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLength: 30,
    );
  }

  Widget buildEmail(UserNotifier authNotifier) {
    return BuildTextField(
      labelText: 'อีเมล',
      hintText: 'กรุณากรอกอีเมล',
      textEditingController: authNotifier.email,
      textInputType: TextInputType.emailAddress,
      validator: (value) {
        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$)';
        final regExp = RegExp(pattern);

        if (value.isEmpty) {
          return 'กรุณากรอกอีเมล';
        } else if (!regExp.hasMatch(value)) {
          return 'กรุณากรอกอีเมลให้ถูกต้อง';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildPhoneNumber(UserNotifier authNotifier) {
    return BuildTextField(
      labelText: 'เบอร์โทรศัพท์',
      textEditingController: authNotifier.phone,
      hintText: 'กรุณาระบุเบอรืโทรศัพท์',
      textInputType: TextInputType.phone,
      validator: (value) {
        if (value.length != 10 || value[0] != '0') {
          return 'โปรดระบุเบอร์โทรศัพท์ให้ถูกต้อง';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildPassword(UserNotifier authNotifier) {
    return BuildPasswordField(
      textEditingController: authNotifier.password,
      labelText: 'รหัสผ่าน',
      hintText: 'กรุณากรอกรหัสผ่าน',
      validator: (value) {
        if (value.length < 8) {
          return 'รหัสผ่านห้ามมีความยาวน้อยกว่า 8 ';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildConfirmPassword(UserNotifier authNotifier) {
    return BuildPasswordField(
      hintText: 'กรุณายืนยันรหัสผ่าน',
      labelText: 'ยืนยันรหัสผ่าน',
      textEditingController: authNotifier.confirmPassword,
      validator: (value) {
        if (value != authNotifier.password.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => password = value),
    );
  }

  Widget buildSubmit(UserNotifier authNotifier) {
    return ButtonWidget(
      text: 'ลงทะเบียน',
      onClicked: () async {
        if (!await authNotifier.signUp()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Register failed")));
          return;
        }
        authNotifier.clearController();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
            (route) => false);
        FocusScope.of(context).unfocus();
      },
    );
  }
}
