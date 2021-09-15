import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/address/add_address.dart';
import 'package:cs_senior_project/screens/address/select_address.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({Key key, @required this.uid}) : super(key: key);

  final String uid;

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  void initState() {
    AddressNotifier addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    getAddress(addressNotifier, widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    AddressNotifier addressNotifier = Provider.of<AddressNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTitle: 'เลือกที่อยู่',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: StadiumButtonWidget(
                  text: 'เลือกบนแผนที่',
                  onClicked: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelectAddress(),
                    ));
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: StadiumButtonWidget(
                  text: 'เพิ่มที่อยู่ใหม่',
                  onClicked: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddAddress()));
                  },
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'ที่อยู่ของคุณ',
                          style: FontCollection.topicTextStyle,
                        ),
                      ),
                      Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: addressNotifier.addressList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                  addressNotifier
                                      .addressList[index].addressName,
                                  style: FontCollection.bodyTextStyle),
                              subtitle: AutoSizeText(
                                addressNotifier.addressList[index].address,
                                maxLines: 2,
                              ),
                              onTap: () {
                                userNotifier.updateUserData({
                                  "selectedAddress": {
                                    "residentName": addressNotifier
                                        .addressList[index].residentName,
                                    "address": addressNotifier
                                        .addressList[index].address,
                                    "addressName": addressNotifier
                                        .addressList[index].addressName,
                                    "addressDetail": addressNotifier
                                        .addressList[index].addressDetail,
                                    "geoPoint": addressNotifier
                                        .addressList[index].geoPoint,
                                    "phone":
                                        addressNotifier.addressList[index].phone
                                  }
                                });

                                addressNotifier.setSelectedAddress(
                                  addressNotifier.addressList[index].address,
                                );
                                userNotifier.reloadUserModel();
                                Navigator.pop(context);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
