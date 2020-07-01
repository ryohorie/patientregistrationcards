import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:patientregistrationcards/models/prescription.dart';
import 'package:patientregistrationcards/utils/utils.dart';
import 'package:photo_view/photo_view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PrescriptionPhotoPage extends StatefulWidget {
  PrescriptionPhotoPage({Key key, this.prescription, this.prescriptionId})
      : super(key: key);

  final Map<String, dynamic> prescription;
  final String prescriptionId;

  @override
  _PrescriptionPhotoPageState createState() => _PrescriptionPhotoPageState();
}

class _PrescriptionPhotoPageState extends State<PrescriptionPhotoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              Utils.dateString(
                  dateTime: DateTime.fromMillisecondsSinceEpoch(
                      widget.prescription["createdAt"]),
                  format: 'yyyy年MM月dd日 HH:MM'),
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    Utils.showOkCancelDialog(
                        context: context,
                        title: "確認",
                        message: "削除してもよろしいですか？",
                        onOk: () async {
                          Navigator.pop(context);
                          await Prescription.deletePrescription(
                              widget.prescriptionId);
                          Fluttertoast.showToast(msg: "削除しました");
                        });
                  })
            ]),
        body: PhotoView(
          imageProvider: NetworkImage(widget.prescription["url"]),
        ));
  }
}
