import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patientregistrationcards/utils/firebase_manager.dart';

class User extends ChangeNotifier {
  Map<String, dynamic> data = new Map<String, dynamic>();
  User() {
    fetch();
  }

  Future<void> fetch() async {
    print("fetchUser");
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      Firestore.instance
          .document("users/${user.uid}")
          .snapshots()
          .listen((data) {
        this.data = data.data;
        notifyListeners();
      });
    }
  }

  static Future<void> setProfile(
      {String name,
      String birthYear,
      String birthMonth,
      String birthDay}) async {
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      await Firestore.instance.collection("users").document(user.uid).setData({
        "name": name,
        "birthYear": birthYear,
        "birthMonth": birthMonth,
        "birthDay": birthDay
      });
    }
  }
}
