import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patientregistrationcards/models/profile.dart';
import 'package:patientregistrationcards/utils/firebase_manager.dart';
import 'package:uuid/uuid.dart';

class Card extends ChangeNotifier {
  Map<String, Map<String, dynamic>> cards =
      new Map<String, Map<String, dynamic>>();
  Card() {
    fetch();
  }

  Future<void> fetch() {
    print("fetchCard");
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      Firestore.instance
          .collection("users/${user.uid}/cards")
          .snapshots()
          .listen((data) {
        this.cards.clear();
        data.documents.forEach((doc) {
          this.cards[doc.documentID] = doc.data;
        });
        notifyListeners();
      });
      /*
      Firestore.instance
          .collection("users/${user.uid}/prescriptions")
          .snapshots()
          .listen((data) {
        this.prescriptions.clear();
        data.documents.forEach((doc) {
          this.prescriptions[doc.documentID] = doc.data;
        });
        notifyListeners();
      });
       */
    }
  }

  static Future<void> deleteCard(String id) async {
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      await Firestore.instance
          .collection("users/${user.uid}/cards")
          .document(id)
          .delete();
    }
  }

  static Future<void> createCard(
      {String name, String number, Profile profile}) async {
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      var uuid = Uuid().v4();
      final now = DateTime.now();
      await Firestore.instance
          .collection("users/${user.uid}/cards")
          .document(uuid)
          .setData({
        "owner": profile.id,
        "name": name,
        "number": number,
        "createdAt": now.millisecondsSinceEpoch
      });
    }
  }
}
