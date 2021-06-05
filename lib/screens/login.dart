import 'package:cs_senior_project/screens/register.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                    'ลืมรหัสผ่าน',
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
                    'ลงทะเบียน',
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

  Widget buildEmail() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red),
        ),
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
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => setState(() => email = value),
      );

  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red),
        ),
        validator: (value) {
          if (value.length < 8) {
            return 'รหัสผ่านห้ามมีความยาวน้อยกว่า 8 ';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => password = value),
        obscureText: true,
      );

  Widget buildSubmit() => ButtonWidget(
        text: 'Submit',
        onClicked: () {
          final isValid = formKey.currentState.validate();
          FocusScope.of(context).unfocus();
        },
      );
}
