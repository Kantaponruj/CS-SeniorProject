import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_stores/models/user.dart';
import 'package:google_map_stores/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserNotifier with ChangeNotifier {
  User _user;
  Status _status = Status.Uninitialized;
  UserService _userService = UserService();
  UserModel _userModel;

  // getter
  User get user => _user;
  Status get status => _status;
  UserModel get userModel => _userModel;

  // public variables
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController displayName = TextEditingController();

  final Future<FirebaseApp> initialization = Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  UserNotifier.initialize() {
    _fireSetUp();
  }

  _fireSetUp() async {
    await initialization.then((value) {
      auth.authStateChanges().listen(_onStateChanged);
    });
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) async {
        await prefs.setString("uid", value.user.uid);
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String _deviceToken = await fcm.getToken();
        await prefs.setString("uid", result.user.uid);
        _userService.createUser(
          uid: result.user.uid,
          displayName: displayName.text.trim(),
          email: email.text.trim(),
          token: _deviceToken,
          // position: position.toJson(),
        );
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    displayName.text = "";
    email.text = "";
    password.text = "";
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userService.getUserById(user.uid);
    notifyListeners();
  }

  updateUserData(Map<String, dynamic> data) async {
    _userService.updateUserData(data);
  }

  saveDeviceToken() async {
    String deviceToken = await fcm.getToken();
    if (deviceToken != null) {
      _userService.addDeviceToken(uid: user.uid, token: deviceToken);
    }
  }

  saveUserLocation(String uid, String address, Position position) {
    _userService.addUserLocation(
        uid: user.uid, address: address, position: position);
  }

  _onStateChanged(User firebaseUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      await prefs.setString("uid", firebaseUser.uid);

      _userModel = await _userService.getUserById(user.uid).then((value) {
        _status = Status.Authenticated;
        return value;
      });
    }
    notifyListeners();
  }
}
