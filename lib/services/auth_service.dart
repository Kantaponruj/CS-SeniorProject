import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_map_stores/models/customer.dart';
import 'package:google_map_stores/notifiers/auth_notifier.dart';

login(Customer customer, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: customer.email, password: customer.password)
      .catchError((error) => print(error));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      firebaseUser.updateProfile(displayName: customer.displayName);
      await firebaseUser.reload();
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
      FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'displayName': customer.displayName,
        'email': customer.email,
        // 'realtimeLocation': GeoPoint(0, 0)
      }).catchError((error) => print("Failed to add user: $error"));
      await firebaseUser.updateProfile(displayName: customer.displayName);
      await firebaseUser.reload();
      User currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}
