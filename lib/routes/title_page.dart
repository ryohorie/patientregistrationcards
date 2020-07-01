import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patientregistrationcards/routes/home_page.dart';
import 'package:patientregistrationcards/utils/firebase_manager.dart';

import 'signin_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class TitlePage extends StatefulWidget {
  TitlePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TitleState createState() => _TitleState();
}

class _TitleState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final FirebaseUser user = await _auth.currentUser();
        _auth.signOut();
        if (user == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => SignInPage()),
          );
        } else {
          FirebaseManager.instance.user = user;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => HomePage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            child: Image.asset("assets/images/logo.png"),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
