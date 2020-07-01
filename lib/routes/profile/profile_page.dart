import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:patientregistrationcards/models/profile.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  Profile profile = new Profile();

  TextEditingController _controllerName = new TextEditingController();
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "プロフィール",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle),
              color: Colors.white,
              onPressed: () {
                _showProfileDialog(context, this.profile);
              },
            )
          ],
        ),
        body: buildList(context));
  }

  _showProfileDialog(BuildContext context, Profile profile) async {
    var now = DateTime.now();
    var years = listToDropDownItems(
        List<String>.generate(120, (i) => (now.year - 120 + i).toString()));
    var months = listToDropDownItems(
        List<String>.generate(12, (i) => (1 + i).toString()));
    var days = listToDropDownItems(
        List<String>.generate(31, (i) => (1 + i).toString()));
    _controllerName.text = profile.name;
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "プロフィール",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("氏名"),
                      TextField(
                        controller: _controllerName,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 24),
                      ),
                      SizedBox(height: 30),
                      Text("生年月日"),
                      Row(children: [
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              value: profile.birthYear,
                              onChanged: (val) {
                                setState(() {
                                  profile.birthYear = val;
                                  print(val);
                                });
                              },
                              items: years),
                        ),
                        Text("年"),
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              value: profile.birthMonth,
                              onChanged: (val) {
                                setState(() {
                                  profile.birthMonth = val;
                                });
                              },
                              items: months),
                        ),
                        Text("月"),
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              value: profile.birthDay,
                              onChanged: (val) {
                                setState(() {
                                  profile.birthDay = val;
                                });
                              },
                              items: days),
                        ),
                        Text("日"),
                      ])
                    ]),
                actions: [
                  FlatButton(
                    child: Text("保存"),
                    onPressed: () async {
                      profile.name = _controllerName.text;
                      print(profile.name);
                      await profile.save();
                      Fluttertoast.showToast(msg: "プロフィールを保存をしました。");
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        });
  }

  listToDropDownItems(list) {
    return list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: SizedBox(
          width: 200,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }).toList();
  }

  Widget buildList(BuildContext context) {
    final profiles = Provider.of<Profiles>(context);
    List<Widget> widgets = new List<Widget>();
    profiles.profiles.forEach((String key, Profile profile) {
      widgets.add(ListTile(
          title: Text(
            profile.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          subtitle: Text(profile.strBirthday,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24)),
          onTap: () {
            _showProfileDialog(context, profile);
          },
          isThreeLine: true));
    });

    return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: profiles.profiles.length,
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
            ),
        itemBuilder: (BuildContext itemContext, int index) {
          return widgets[index];
        });
  }
  /*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<User>(context);
    _controllerName.text = user.name;
    this.birthYear = user.birthYear;
    this.birthMonth = user.birthMonth;
    this.birthDay = user.birthDay;
  }

  TextEditingController _controllerName = new TextEditingController();
  final _scrollController = ScrollController();
  _ProfilePageState();
  String birthYear, birthMonth, birthDay;

  listToDropDownItems(list) {
    return list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: SizedBox(
          width: 200,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var years = listToDropDownItems(
        List<String>.generate(120, (i) => (now.year - 120 + i).toString()));
    var months = listToDropDownItems(
        List<String>.generate(12, (i) => (1 + i).toString()));
    var days = listToDropDownItems(
        List<String>.generate(31, (i) => (1 + i).toString()));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "プロフィール",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {},
              color: Colors.white,
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("氏名"),
                  TextField(
                    controller: _controllerName,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
                  ),
                  SizedBox(height: 30),
                  Text("生年月日"),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                            isExpanded: true,
                            value: this.birthYear,
                            onChanged: (val) {
                              setState(() {
                                this.birthYear = val;
                              });
                            },
                            items: years),
                      ),
                      Text("年"),
                      Expanded(
                        child: DropdownButton(
                            isExpanded: true,
                            value: this.birthMonth,
                            onChanged: (val) {
                              setState(() {
                                this.birthMonth = val;
                              });
                            },
                            items: months),
                      ),
                      Text("月"),
                      Expanded(
                        child: DropdownButton(
                            isExpanded: true,
                            value: this.birthDay,
                            onChanged: (val) {
                              setState(() {
                                this.birthDay = val;
                              });
                            },
                            items: days),
                      ),
                      Text("日"),
                    ],
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text("保存",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () async {
                      if (!this._controllerName.text.isEmpty &&
                          !this.birthYear.isEmpty &&
                          !this.birthMonth.isEmpty &&
                          !this.birthDay.isEmpty) {
                        await User.setProfile(
                            name: this._controllerName.text,
                            birthYear: this.birthYear,
                            birthMonth: this.birthMonth,
                            birthDay: this.birthDay);
                        Fluttertoast.showToast(msg: "保存しました。");
                      } else {
                        Fluttertoast.showToast(
                            msg: "すべての項目を入力してください。",
                            backgroundColor: Colors.red);
                      }
                    },
                  ),
                ])));
  }
   */
}
