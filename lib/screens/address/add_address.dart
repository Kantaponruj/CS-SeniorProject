import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/orderCard.dart';
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
    _currentAddress.geoPoint = GeoPoint(
        locationNotifier.currentPosition.latitude,
        locationNotifier.currentPosition.longitude);
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
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: StadiumButtonWidget(
                    text: 'เลือกบนแผนที่',
                    onClicked: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SelectAddress(isAdding: true),
                        ),
                      );
                    },
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
                          child: Text(locationNotifier.currentAddress != null
                              ? locationNotifier.currentAddress
                              : 'กรุณาเลือกที่อยู่'),
                        ),
                        Container(
                          child: buildTextFormField(
                            'ชื่อสถานที่',
                            TextInputType.text,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },
                            addressName,
                          ),
                        ),
                        Container(
                          child: buildTextFormField(
                            'รายละเอียดสถานที่',
                            TextInputType.text,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },
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
                            TextInputType.text,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },
                            residentName,
                          ),
                        ),
                        Container(
                          child: buildTextFormField(
                            'เบอร์โทรศัพท์',
                            TextInputType.number,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
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
                      locationNotifier.initialPosition;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _saveAddress(locationNotifier);
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

  Widget buildTextFormField(String labelText, TextInputType keyboardType,
      String Function(String) validator, TextEditingController controller) {
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
        controller: controller,
        validator: validator,
      ),
    );
  }
}
