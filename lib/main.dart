// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:patientregistrationcards/models/card.dart' as prcard;
import 'package:patientregistrationcards/models/prescription.dart';
import 'package:patientregistrationcards/routes/title_page.dart';
import 'package:provider/provider.dart';

import 'models/profile.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<prcard.Card>(create: (_) => prcard.Card()),
        ChangeNotifierProvider<Prescription>(create: (_) => Prescription()),
        ChangeNotifierProvider<Profiles>(create: (_) => Profiles()),
        ChangeNotifierProvider<User>(create: (_) => User()),
      ],
      child: MaterialApp(
        title: 'Firebase Auth Demo',
        home: TitlePage(title: 'Firebase Auth Demo'),
        theme: ThemeData(
          primaryColor: Colors.lightBlue,
          accentColor: Colors.cyan[600],
        ),
      ),
    );
  }
}
