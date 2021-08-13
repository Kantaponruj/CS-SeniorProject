import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(appBarTitle: 'ข้อมูลที่อยู่',),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: StadiumButtonWidget(
                    text: 'เลือกบนแผนที่',
                    onClicked: () {},
                  ),
                ),
                BuildCard(
                  headerText: 'ที่อยู่',
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('กรุณาเลือกที่อยู่'),
                        ),
                        Container(
                          child: buildTextFormField('ชื่อสถานที่',
                            TextInputType.text, (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },),
                        ),
                        Container(
                          child: buildTextFormField('รายละเอียดสถานที่',
                            TextInputType.text, (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },),
                        ),
                      ],
                    ),
                  ),
                  canEdit: false,
                ),
                BuildCard(
                  headerText: 'ข้อมูลการติดต่อ',
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          child: buildTextFormField('ชื่อ',
                            TextInputType.text, (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },),
                        ),
                        Container(
                          child: buildTextFormField('เบอร์โทรศัพท์',
                            TextInputType.number, (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },),
                        ),
                        Container(
                          child: buildTextFormField('เพิ่มเติม',
                            TextInputType.text, (value) {
                              if (value.isEmpty) {
                                return 'เพิ่มเติม';
                              }
                              return null;
                            },),
                        ),
                      ],
                    ),
                  ),
                  canEdit: false,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: StadiumButtonWidget(
                    text: 'บันทึก',
                    onClicked: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String labelText, TextInputType keyboardType,
      String Function(String) validator,) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red),
        ),
        keyboardType: keyboardType,
        // controller: controller,
        validator: validator,
        // onSaved: (value) => setState(() => password = value),
        obscureText: true,
      ),
    );
  }
}
