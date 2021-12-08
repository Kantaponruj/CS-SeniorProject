import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_address.dart';

class Address extends StatefulWidget {
  Address({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  void initState() {
    super.initState();
    AddressNotifier addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    getAddress(addressNotifier, widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    AddressNotifier addressNotifier = Provider.of<AddressNotifier>(context);

    Future<void> _refreshList() async {
      getAddress(addressNotifier, widget.uid);
    }

    return SafeArea(
      child: Scaffold(
          appBar: RoundedAppBar(
            appBarTitle: 'ที่อยู่ของคุณ',
          ),
          body: SingleChildScrollView(
            child: new RefreshIndicator(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    // isFromHomePage ? selectedOnMap() : SizedBox.shrink(),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
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
                              trailing: GestureDetector(
                                onTap: () {
                                  addressNotifier.currentAddress =
                                      addressNotifier.addressList[index];
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddAddress(isUpdating: true, isDelete: true,),
                                    ),
                                  );
                                },
                                child: Icon(Icons.edit),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: StadiumButtonWidget(
                        text: 'เพิ่มที่อยู่ใหม่',
                        onClicked: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddAddress(isUpdating: false,isDelete: false,)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              onRefresh: _refreshList,
            ),
          )),
      // ),
    );
  }

// Widget selectedOnMap() {
//   return Container(
//     child: Column(
//       children: [
//         Container(
//           margin: EdgeInsets.only(bottom: 20),
//           child: StadiumButtonWidget(
//             text: 'เลือกบนแผนที่',
//             onClicked: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => SelectAddress(isAdding: false),
//                 ),
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20),
//           child: Divider(),
//         ),
//       ],
//     ),
//   );
// }
}
