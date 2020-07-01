import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:patientregistrationcards/models/profile.dart';

class Utils {
  static String elapsedTimeString(int time) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int elapsed = ((now - time) / 1000).floor();
    if (elapsed < 0) {
      return "";
    }

    if (elapsed < 60) {
      return "${(elapsed).floor()}秒前";
    }
    if (elapsed < 60 * 60) {
      return "${(elapsed / 60).floor()}分前";
    }
    if (elapsed < 60 * 60 * 24) {
      return "${(elapsed / 60 / 60).floor()}時間前";
    }
    return "${(elapsed / 60 / 60 / 24).floor()}日前";
  }

  static String dateString({DateTime dateTime, String format: 'yyyyMMdd'}) {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat(format, "ja_JP");
    return formatter.format(dateTime); // DateからString
  }

  static _listToDropDownItems(list) {
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

  static showProfileDialog(
      {BuildContext context, Profile profile, Function onSave}) async {
    TextEditingController _controllerName = new TextEditingController();
    var now = DateTime.now();
    var years = _listToDropDownItems(
        List<String>.generate(120, (i) => (now.year - 120 + i + 1).toString()));
    var months = _listToDropDownItems(
        List<String>.generate(12, (i) => (1 + i).toString()));
    var days = _listToDropDownItems(
        List<String>.generate(31, (i) => (1 + i).toString()));
    _controllerName.text = profile.name;
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "プロフィール登録",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                            flex: 4),
                        Expanded(child: Text("年"), flex: 1),
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
                            flex: 3),
                        Expanded(
                          child: Text("月"),
                          flex: 1,
                        ),
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
                            flex: 3),
                        Expanded(child: Text("日"), flex: 1),
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

  static showOkCancelDialog(
      {BuildContext context,
      String title,
      String message,
      Function onOk,
      Function onCancel}) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Text(message)]),
            actions: [
              FlatButton(
                child: Text("キャンセル"),
                onPressed: () async {
                  if (onCancel != null) {
                    onCancel();
                  }
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () async {
                  if (onOk != null) {
                    onOk();
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
