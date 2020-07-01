import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as ImageUtils;
import 'package:image_picker/image_picker.dart';
import 'package:patientregistrationcards/models/prescription.dart';
import 'package:patientregistrationcards/models/profile.dart';
import 'package:patientregistrationcards/routes/prescriptions/prescription_photo_page.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PrescriptionsPage extends StatelessWidget {
  final Profile profile;
  TextEditingController _controller = new TextEditingController();
  final _scrollController = ScrollController();
  PrescriptionsPage({this.profile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "お薬手帳",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
              )),
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                var file =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                addImageFile(file);
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () async {
                var file =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                addImageFile(file);
              },
              color: Colors.white,
            )
          ],
        ),
        body: buildList(context));
  }

  Future<void> addImageFile(file) {
    ImageUtils.Image image = ImageUtils.decodeImage(file.readAsBytesSync());
    if (image != null) {
      ImageUtils.Image thumbnail = null;
      int size = 1280;
      if (image.width < image.height) {
        thumbnail = ImageUtils.copyResize(image, width: size);
      } else {
        thumbnail = ImageUtils.copyResize(image, height: size);
      }
      Prescription.createPrescription(profile: profile, image: thumbnail);
      Fluttertoast.showToast(msg: "処方箋を登録しました。");
    }
  }

  Widget buildList(BuildContext context) {
    final prescription = Provider.of<Prescription>(context);
    List<Widget> widgets = new List<Widget>();
    prescription.prescriptions
        .forEach((String key, Map<String, dynamic> prescription) {
      if (prescription["owner"] == profile.id) {
        widgets.add(GridTile(
            child: InkResponse(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescriptionPhotoPage(
                              prescription: prescription,
                              prescriptionId: key,
                            )),
                  );
                },
                child: Image.network(prescription["url"]))));
      }
    });
    return GridView.count(
        crossAxisCount: 2,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: widgets);
  }
}
