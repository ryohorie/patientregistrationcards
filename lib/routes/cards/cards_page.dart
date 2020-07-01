import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:patientregistrationcards/models/card.dart' as prcard;
import 'package:patientregistrationcards/models/profile.dart';
import 'package:patientregistrationcards/models/user.dart';
import 'package:patientregistrationcards/utils/utils.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CardsPage extends StatelessWidget {
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerNumber = new TextEditingController();
  final _scrollController = ScrollController();
  final Profile profile;
  CardsPage({this.profile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "診察券一覧",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
              )),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle),
              color: Colors.white,
              onPressed: () {
                _showCreateDialog(context);
              },
            )
          ],
        ),
        body: buildList(context));
  }

  _showCreateDialog(BuildContext context) async {
    _controllerNumber.text = "";
    _controllerName.text = "";
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(
              "診察券",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: TextField(
                    controller: _controllerName,
                    decoration: InputDecoration(labelText: "病院・クリニック名"),
                    onChanged: (text) {},
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: _controllerNumber,
                    decoration: InputDecoration(labelText: "No."),
                    onChanged: (text) {},
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("作成"),
                onPressed: () async {
                  if (_controllerName.text.length >= 3 &&
                      _controllerNumber.text.length >= 3) {
                    await prcard.Card.createCard(
                        profile: profile,
                        name: _controllerName.text,
                        number: _controllerNumber.text);
                    Fluttertoast.showToast(msg: "診察券を登録しました。");
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  _showCardDialog(
      {BuildContext context,
      Map<String, dynamic> card,
      User user,
      String cardId}) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            contentPadding: MediaQuery.of(context).viewInsets +
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            title: Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Text(
                    card["name"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {
                        Utils.showOkCancelDialog(
                            context: context,
                            title: "確認",
                            message: "削除してもよろしいですか？",
                            onOk: () async {
                              Navigator.pop(context);
                              prcard.Card.deleteCard(cardId);
                              Fluttertoast.showToast(msg: "削除しました");
                            });
                      },
                    ))
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: TextEditingController(text: card["number"]),
                  decoration: InputDecoration(labelText: "No."),
                  readOnly: true,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
                TextField(
                  controller: TextEditingController(text: profile.strBirthday),
                  decoration: InputDecoration(labelText: "生年月日"),
                  readOnly: true,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
                TextField(
                  controller: TextEditingController(text: profile.name),
                  decoration: InputDecoration(labelText: "氏名"),
                  readOnly: true,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ],
            ),
          );
        });
  }

  Widget buildList(BuildContext context) {
    final card = Provider.of<prcard.Card>(context);
    final user = Provider.of<User>(context);
    List<Widget> widgets = new List<Widget>();
    card.cards.forEach((String key, Map<String, dynamic> card) {
      if (card["owner"] == profile.id) {
        widgets.add(ListTile(
            title: Text(
              card["name"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              textAlign: TextAlign.left,
            ),
            subtitle: Text("No." + card["number"],
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24)),
            onTap: () {
              _showCardDialog(
                  context: context, card: card, user: user, cardId: key);
            },
            isThreeLine: true));
      }
    });
    return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: widgets.length,
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
            ),
        itemBuilder: (BuildContext itemContext, int index) {
          return widgets[index];
        });
  }
}
