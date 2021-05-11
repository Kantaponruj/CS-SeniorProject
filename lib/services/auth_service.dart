import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_stores/models/customer.dart';
import 'package:google_map_stores/notifiers/auth_notifier.dart';
import 'package:google_map_stores/screens/home.dart';

login(Customer customer, AuthNotifier authNotifier) async {
  BuildContext context;
  UserCredential authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: customer.email, password: customer.password)
      .then((currentUser) => FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.user.uid)
          .get()
          .then((DocumentSnapshot result) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        uid: currentUser.user.uid,
                      )),
              (_) => false)))
      .catchError((error) => print(error));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print('Login with: $firebaseUser');
      authNotifier.setUser(firebaseUser);
    }
  }
}

register(Customer customer, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: customer.email, password: customer.password)
      .catchError((error) => print(error));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      BuildContext context;
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .set({
            'uid': firebaseUser.uid,
            'userName': customer.userName,
            'email': customer.email,
            // 'realtimeLocation': GeoPoint(0, 0)
          })
          .then((currentUser) => {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(uid: firebaseUser.uid)),
                    (_) => false),
                print("User Added")
              })
          .catchError((error) => print("Failed to add user: $error"));
      // await firebaseUser.updateProfile(displayName: consumer.displayName);
      await firebaseUser.reload();
      User currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier.setUser(currentUser);
    }
  }
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}
