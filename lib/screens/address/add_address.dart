import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
import 'package:cs_senior_project/component/textformfield.dart';
import 'package:cs_senior_project/models/address.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/address/select_address.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  AddressModel _currentAddress;

  TextEditingController addressName = new TextEditingController();
  TextEditingController addressDetail = new TextEditingController();
  TextEditingController residentName = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  @override
  void initState() {
    _currentAddress = AddressModel();
    super.initState();
  }

  _onAddAddress(AddressModel address) {
    AddressNotifier addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    addressNotifier.addAddress(address);
    Navigator.pop(context);
  }

  _saveAddress(LocationNotifier locationNotifier) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    _currentAddress.address = locationNotifier.currentAddress;
    _currentAddress.geoPoint = locationNotifier.addingPosition != null
        ? GeoPoint(
            locationNotifier.addingPosition.latitude,
            locationNotifier.addingPosition.longitude,
          )
        : GeoPoint(
            locationNotifier.currentPosition.latitude,
            locationNotifier.currentPosition.longitude,
          );
    _currentAddress.addressName = addressName.text.trim();
    _currentAddress.addressDetail = addressDetail.text.trim();
    _currentAddress.residentName = residentName.text.trim();
    _currentAddress.phone = phone.text.trim();

    addAddress(_currentAddress, userNotifier.userModel.uid, _onAddAddress);
  }

  @override
  Widget build(BuildContext context) {
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'ข้อมูลที่อยู่',
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                BuildCard(
                  headerText: 'ที่อยู่',
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            alignment: Alignment.topRight,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SelectAddress(isAdding: true),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  primary: Theme.of(context).buttonColor),
                              child: Text(
                                'เลือกบนแผนที่',
                                style: FontCollection.smallBodyTextStyle,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(locationNotifier.currentAddress != null
                              ? locationNotifier.currentAddress
                              : 'กรุณาเลือกที่อยู่'),
                        ),
                        Container(
                          child: buildTextFormField(
                            'ชื่อสถานที่',
                            'กรุณากรอกชื่อสถานที่',
                            TextInputType.text,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดระบุชื่อ';
                              }
                              return null;
                            },
                            addressName,
                          ),
                        ),
                        Container(
                          child: buildTextFormField(
                            'รายละเอียดสถานที่',
                            'กรุณากรอกรายละเอียด',
                            TextInputType.text,
                            (value) {},
                            addressDetail,
                          ),
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
                          child: buildTextFormField(
                            'ชื่อ',
                            'กรุณากรอกชื่อ',
                            TextInputType.text,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดระบุชื่อ';
                              }
                              return null;
                            },
                            residentName,
                          ),
                        ),
                        Container(
                          child: buildTextFormField(
                            'เบอร์โทรศัพท์',
                            '0XXXXXXXXX',
                            TextInputType.number,
                            (value) {
                              if (value.length != 10 ||
                                  value[0] != '0' ||
                                  value.isEmpty) {
                                return 'โปรดระบุเบอร์โทรศัพท์ให้ถูกต้อง';
                              }
                              return null;
                            },
                            phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  canEdit: false,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: StadiumButtonWidget(
                    text: 'บันทึก',
                    onClicked: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _saveAddress(locationNotifier);
                      locationNotifier.initialization();
                      locationNotifier.addingPosition = null;
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

  Widget buildTextFormField(String labelText, String hintText, TextInputType keyboardType,
      String Function(String) validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BuildTextField(
        labelText: labelText,
        hintText: hintText,
        textInputType: keyboardType,
        textEditingController: controller,
        validator: validator,
      ),
    );
  }
}
