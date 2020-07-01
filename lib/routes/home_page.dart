import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patientregistrationcards/models/profile.dart';
import 'package:patientregistrationcards/routes/cards/cards_page.dart';
import 'package:patientregistrationcards/routes/prescriptions/prescriptions_page.dart';
import 'package:patientregistrationcards/routes/profile/profiles_drawer.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _currentPage = 0;
  PageController _pageController = new PageController();
  Profile _selectedProfile = null;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profiles = Provider.of<Profiles>(context);
    var hasProfile = profiles.profiles.isNotEmpty;
    if (_selectedProfile == null && hasProfile) {
      String key = profiles.profiles.keys.first;
      _selectedProfile = profiles.profiles[key];
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (profiles.profiles.isEmpty) {
        _scaffoldKey.currentState.openDrawer();
      }
    });
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Tooltip(message: 'プロフィール', child: Icon(Icons.account_circle)),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            _selectedProfile != null ? _selectedProfile.name : "←プロフィール登録",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: ProfilesDrawer(
            context: context,
            profiles: profiles,
            onSelectProfile: (profile) {
              setState(() {
                _selectedProfile = profile;
              });
            }),
        bottomNavigationBar: hasProfile
            ? BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.credit_card), title: Text("診察券")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.library_books), title: Text("お薬手帳")),
                ],
                currentIndex: _currentPage,
                onTap: (int index) {
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                },
              )
            : null,
        body: hasProfile
            ? PageView(
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: [
                    CardsPage(profile: _selectedProfile),
                    PrescriptionsPage(profile: _selectedProfile),
                  ])
            : Container());
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentPage = page;
    });
  }
}
