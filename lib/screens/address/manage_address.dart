import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/notifiers/address_notifier.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/screens/address/add_address.dart';
import 'package:cs_senior_project/screens/address/select_address.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress(
      {Key key, @required this.uid, this.storePoint, this.isDelivery})
      : super(key: key);

  final String uid;
  final LatLng storePoint;
  final bool isDelivery;

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
    AddressNotifier addressNotifier = Provider.of<AddressNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    return Scaffold(
      appBar: RoundedAppBar(
        appBarTitle: 'เลือกที่อยู่',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: StadiumButtonWidget(
                text: 'เลือกบนแผนที่',
                onClicked: () {
                  if (widget.storePoint != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelectAddress(
                        storePoint: widget.storePoint,
                        isDelivery: widget.isDelivery,
                        isAdding: false,
                      ),
                    ));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelectAddress(isAdding: false),
                    ));
                  }
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: addressNotifier.addressList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              addressNotifier.addressList[index].addressName,
                              style: FontCollection.bodyTextStyle,
                            ),
                            subtitle: AutoSizeText(
                              addressNotifier.addressList[index].address,
                              maxLines: 2,
                            ),
                            onTap: () {
                              locationNotifier.setCameraPositionMap(
                                LatLng(
                                  addressNotifier
                                      .addressList[index].geoPoint.latitude,
                                  addressNotifier
                                      .addressList[index].geoPoint.longitude,
                                ),
                              );

                              locationNotifier.setSelectedPosition(
                                addressNotifier.addressList[index],
                              );

                              if (widget.storePoint != null) {
                                orderNotifier.setPolylines(
                                  locationNotifier,
                                  LatLng(
                                    widget.storePoint.latitude,
                                    widget.storePoint.longitude,
                                  ),
                                  widget.isDelivery,
                                );
                              }

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
    );
  }
}
