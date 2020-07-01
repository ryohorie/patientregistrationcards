import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patientregistrationcards/utils/firebase_manager.dart';
import 'package:uuid/uuid.dart';

class Profiles extends ChangeNotifier {
  Map<String, Profile> profiles = new Map<String, Profile>();
  Profiles() {
    fetch();
  }
  Future<void> checkProfile(Profile profile) async {
    if (!profiles.containsKey(profile.id)) {
      await profile.save();
    }
  }

  Future<void> fetch() async {
    print("fetchProfiles");
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      Firestore.instance
          .document("users/${user.uid}")
          .collection("profiles")
          .snapshots()
          .listen((data) {
        this.profiles.clear();
        data.documents.forEach((doc) {
          var profile = new Profile();
          profile.id = doc.documentID;
          profile.birthYear = doc.data['birthYear'];
          profile.name = doc.data['name'] != null ? doc.data['name'] : "";
          profile.birthMonth = doc.data['birthMonth'];
          profile.birthDay = doc.data['birthDay'];
          this.profiles[doc.documentID] = profile;
        });
        notifyListeners();
      });
    }
  }
}

class Profile extends ChangeNotifier {
  String id = Uuid().v4();
  String name = "";
  String birthYear = "1950";
  String birthDay = "1";
  String birthMonth = "1";

  get strBirthday {
    return "${this.birthYear}年${this.birthMonth}月${this.birthDay}日";
  }

  Future<void> save() async {
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      await Firestore.instance
          .collection("users")
          .document(user.uid)
          .collection("profiles")
          .document(this.id)
          .setData({
        "name": this.name,
        "birthYear": this.birthYear,
        "birthMonth": this.birthMonth,
        "birthDay": this.birthDay
      });
    }
  }
}
