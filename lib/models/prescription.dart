import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageUtils;
import 'package:patientregistrationcards/models/profile.dart';
import 'package:patientregistrationcards/utils/firebase_manager.dart';
import 'package:uuid/uuid.dart';

class Prescription extends ChangeNotifier {
  Map<String, Map<String, dynamic>> prescriptions =
      new Map<String, Map<String, dynamic>>();
  Prescription() {
    fetch();
  }

  Future<void> fetch() {
    print("fetchPrescription");
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
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
    }
  }

  static Future<String> uploadImage() async {}

  static Future<void> deletePrescription(String id) async {
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      await Firestore.instance
          .collection("users/${user.uid}/prescriptions")
          .document(id)
          .delete();
    }
  }

  static Future<void> createPrescription(
      {ImageUtils.Image image, Profile profile}) async {
    FirebaseUser user = FirebaseManager.instance.user;
    if (user != null) {
      var uuid = Uuid().v4();
      final storage = FirebaseStorage.instance
          .ref()
          .child("/${user.uid}/prescriptions/${uuid}.png");
      StorageUploadTask uploadTask =
          storage.putData(ImageUtils.encodePng(image));
      await uploadTask.onComplete;
      String url = await storage.getDownloadURL();

      final now = DateTime.now();
      await Firestore.instance
          .collection("users/${user.uid}/prescriptions")
          .document(uuid)
          .setData({
        "owner": profile.id,
        "url": url,
        "createdAt": now.millisecondsSinceEpoch,
      });
      return url;
    } else {
      return "";
    }
  }
}
