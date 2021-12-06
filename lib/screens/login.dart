import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/component/textformfield.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/forget_password.dart';
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
              child: Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                  primary: CollectionsColors.orange,
                )),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child:
                              Image.asset('assets/images/stalltruckr_logo.png'),
                        ),
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
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              EditButton(
                                onClicked: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ForgetPasswordPage(),
                                    ),
                                  );
                                },
                                editText: 'ลืมรหัสผ่าน',
                              ),
                              buildSubmit(),
                            ],
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
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text('หากคุณยังไม่มีบัญชี ',
                                    style: FontCollection.bodyTextStyle),
                              ),
                              InkWell(
                                onTap: () => register(context),
                                child: Text(
                                  'ลงทะเบียนที่นี่',
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
            ),
    );
  }

  Widget buildEmail() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

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
      // onSaved: (value) => setState(() => email = value),
    );
  }

  Widget buildPassword() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return BuildPasswordField(
      labelText: 'รหัสผ่าน',
      hintText: 'กรุณากรอกรหัสผ่าน',
      textEditingController: authNotifier.password,
      validator: (value) {
        if (value.isEmpty) {
          return 'โปรดระบุรหัสผ่าน';
        }
        return null;
      },
      // onSaved: (value) => setState(() => password = value),
    );
  }

  Widget buildSubmit() {
    UserNotifier authNotifier = Provider.of<UserNotifier>(context);

    return ButtonWidget(
      text: 'เข้าสู่ระบบ',
      width: 150,
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
