import 'package:cs_senior_project/models/address.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/order_notifier.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key key, this.storePoint, this.isDelivery})
      : super(key: key);

  final LatLng storePoint;
  final bool isDelivery;

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  AddressModel _address = AddressModel();

  @override
  void initState() {
    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);
    locationNotifier.initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocationNotifier location = Provider.of<LocationNotifier>(context);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTitle: 'ค้นหาสถานที่',
        ),
        body: Stack(
          children: [
            location.initialPosition == null
                ? LoadingWidget()
                : Container(
                    child: Flexible(
                      flex: 15,
                      child: PlacePicker(
                        apiKey: GOOGLE_MAPS_API_KEY,
                        initialPosition: location.initialPosition,
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        usePlaceDetailSearch: true,
                        onPlacePicked: (selectedPlace) {
                          if (widget.storePoint != null) {
                            orderNotifier.setPolylines(
                              LatLng(
                                selectedPlace.geometry.location.lat,
                                selectedPlace.geometry.location.lng,
                              ),
                              LatLng(
                                widget.storePoint.latitude,
                                widget.storePoint.longitude,
                              ),
                              widget.isDelivery,
                            );
                          }

                          location.setCameraPositionMap(
                            LatLng(
                              selectedPlace.geometry.location.lat,
                              selectedPlace.geometry.location.lng,
                            ),
                          );

                          setState(() {
                            _address.address = selectedPlace.formattedAddress;
                            _address.geoPoint = GeoPoint(
                              selectedPlace.geometry.location.lat,
                              selectedPlace.geometry.location.lng,
                            );
                            _address.phone = userNotifier.userModel.phone;
                            _address.residentName =
                                userNotifier.userModel.displayName;
                          });
                          location.setSelectedPosition(_address);

                          Navigator.of(context).pop();
                        },
                      ),
                      // GoogleMap(
                      //   myLocationEnabled: true,
                      //   mapType: MapType.normal,
                      //   initialCameraPosition: CameraPosition(
                      //     target: location.initialPosition,
                      //     zoom: 18,
                      //   ),
                      //   markers: Set<Marker>.of(location.marker.values),
                      //   onMapCreated: (GoogleMapController controller) {
                      //     _mapController.complete(controller);
                      //   },
                      // ),
                    ),
                  ),
          ],
        ),
        // bottomNavigationBar: Container(
        //   alignment: Alignment.bottomCenter,
        //   height: 180,
        //   margin: EdgeInsets.symmetric(horizontal: 20),
        //   color: Colors.transparent,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
        //         child: Container(
        //           child: Text(location.currentAddress != null
        //               ? location.currentAddress
        //               : 'ที่อยู่'),
        //         ),
        //       ),
        //       StadiumButtonWidget(
        //         text: 'เลือกตำแหน่ง',
        //         onClicked: () {
        //           userNotifier.updateUserData({
        //             'selectedAddress': {
        //               'address': location.currentAddress,
        //               'addressDetail': '',
        //               'addressName': '',
        //               'geoPoint': GeoPoint(location.currentPosition.latitude,
        //                   location.currentPosition.longitude),
        //               'phone': userNotifier.userModel.phone,
        //               'residentName': userNotifier.userModel.displayName,
        //             }
        //           });
        //           userNotifier.reloadUserModel();
        //           Navigator.pop(context);
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
