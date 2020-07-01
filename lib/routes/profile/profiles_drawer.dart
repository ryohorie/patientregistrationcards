import 'package:flutter/material.dart';
import 'package:patientregistrationcards/models/profile.dart';
import 'package:patientregistrationcards/utils/utils.dart';

class ProfilesDrawer extends StatelessWidget {
  ProfilesDrawer({this.profiles, this.onSelectProfile, this.context}) {}
  final Function(Profile) onSelectProfile;
  final Profiles profiles;
  final BuildContext context;

  Widget makeListItem(BuildContext context, Profile profile) {
    return GestureDetector(
      onTap: () {
        this.onSelectProfile(profile);
        Navigator.pop(context);
      },
      child: ListTile(
          title: Text(
            profile.name,
            textAlign: TextAlign.left,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Utils.showProfileDialog(context: context, profile: profile);
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (profiles.profiles.isEmpty) {
        Utils.showProfileDialog(context: context, profile: Profile());
      }
    });
    List<Widget> drawerWidgets = new List<Widget>();
    profiles.profiles.forEach((id, profile) {
      drawerWidgets.add(makeListItem(context, profile));
    });
    drawerWidgets.add(Container(
      child: FlatButton.icon(
        icon: Icon(Icons.add, color: Colors.blue),
        label: Text(
          '新しいプロフィールを登録する',
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          Utils.showProfileDialog(context: context, profile: Profile());
        },
      ),
    ));
    drawerWidgets.add(
      ListTile(),
    );

    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
            child: ListView(padding: EdgeInsets.zero, children: drawerWidgets)),
      ],
    ));
  }
}
