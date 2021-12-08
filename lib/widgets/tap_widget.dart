import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/store_notifier.dart';
import 'package:cs_senior_project/screens/shop/shop_menu.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:cs_senior_project/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TapWidget extends StatefulWidget {
  TapWidget({Key key, @required this.scrollController, this.isDelivery})
      : super(key: key);

  final ScrollController scrollController;
  final bool isDelivery;

  @override
  _TapWidgetState createState() => _TapWidgetState();
}

class _TapWidgetState extends State<TapWidget> {
  List<Store> _storeList = [];

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return StreamBuilder(
      stream: getStores(widget.isDelivery),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        _storeList.clear();

        if (!snapshot.hasData) {
          return LoadingWidget();
        }

        snapshot.data.docs.forEach((document) {
          Store store = Store.fromMap(document.data());
          if (store.storeStatus) {
            _storeList.add(store);
          }
        });

        storeNotifier.storeList = _storeList;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          controller: widget.scrollController,
          itemCount: _storeList.length,
          itemBuilder: (context, index) {
            Store store = _storeList[index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: buildStore(store, context, storeNotifier),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget buildStore(Store store, context, StoreNotifier storeNotifier) {
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    return ListTile(
        leading: ClipOval(
          child: store.image != ""
              ? Image.network(
                  store.image,
                  fit: BoxFit.fill,
                  width: 60,
                  height: 60,
                  // 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                )
              : Image.asset(
                  'assets/images/default-photo.png',
                  fit: BoxFit.fill,
                  width: 60,
                  height: 60,
                ),
          clipper: MyClip(),
        ),
        // Container(
        //   width: 60,
        //   height: 60,
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       image: DecorationImage(
        //         fit: BoxFit.cover,
        //         image: store.image != null
        //             ? NetworkImage(store.image,
        //                 // 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
        //                 )
        //             : AssetImage(
        //                 'assets/images/default-photo.png',
        //               ),
        //       )),
        // ),
        title: Text(
          store.storeName,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(store.kindOfFood.join(', ')),
        trailing: GestureDetector(
          onTap: () {
            locationNotifier.setCameraPositionMap(
              LatLng(
                storeNotifier.currentStore.realtimeLocation.latitude,
                storeNotifier.currentStore.realtimeLocation.longitude,
              ),
            );
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CollectionsColors.yellow,
            ),
            child: Icon(
              Icons.near_me,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () {
          _storeList.forEach((element) {
            if (element.storeId == store.storeId) {
              storeNotifier.currentStore = element;
            }
          });

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShopMenu(),
          ));
        });
  }
}

class MyClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 60, 60);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
