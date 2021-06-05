import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';

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
                  height: 100,
                ),
                Text('Register'),
                SizedBox(height: 20,),
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
                buildPasswordAgain(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUsername() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red),
        ),
        validator: (value) {
          if (value.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },
        maxLength: 30,
        onSaved: (value) => setState(() => username = value),
      );

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

  Widget buildPasswordAgain() => TextFormField(
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
        text: 'Register',
        onClicked: () {
          final isValid = formKey.currentState.validate();
          FocusScope.of(context).unfocus();

          if (isValid) {
            formKey.currentState.save();
          }
        },
      );
}
