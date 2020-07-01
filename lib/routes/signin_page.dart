// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:patientregistrationcards/routes/home_page.dart';
import 'package:patientregistrationcards/utils/firebase_manager.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  final String title = 'ログイン';
  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Container(
            child: _PhoneSignInSection(Scaffold.of(context)),
          ),
        );
      }),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}

class _PhoneSignInSection extends StatefulWidget {
  _PhoneSignInSection(this._scaffold);

  final ScaffoldState _scaffold;
  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<_PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;
  bool _sendedCode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _phoneNumberController,
            decoration:
                const InputDecoration(labelText: '電話番号を入力してください(ハイフンなし)'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Phone number (+x xxx-xxx-xxxx)';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                _verifyPhoneNumber();
              },
              child: const Text(
                '確認コード送信',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          ),
          TextField(
            controller: _smsController,
            decoration: const InputDecoration(labelText: '確認コードを入力してください'),
            enabled: _sendedCode,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: _sendedCode
                  ? () async {
                      _signInWithPhoneNumber();
                    }
                  : null,
              child: const Text(
                'ログイン',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _message,
              style: TextStyle(color: Colors.red),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text("または"),
                RaisedButton(
                  onPressed: () async {
                    _signInAnomymousUser();
                  },
                  child: const Text(
                    '入力せずにログイン',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      widget._scaffold.showSnackBar(const SnackBar(
        content: Text('確認コードを送信しました。'),
      ));
      _verificationId = verificationId;
      setState(() {
        _sendedCode = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+81" + _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void next(FirebaseUser user) async {
    final FirebaseUser currentUser = await _auth.currentUser();
    FirebaseManager.instance.user = currentUser;
    assert(user.uid == currentUser.uid);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => HomePage()),
    );
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    next(user);
  }

  _signInAnomymousUser() async {
    AuthResult result = await _auth.signInAnonymously();
    next(result.user);
  }
}
