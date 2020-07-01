import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  static FirebaseManager _instance; // インスタンスのキャッシュ

  static get instance => new FirebaseManager();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user = null;

  // 初めて呼び出されたときはインスタンスを生成してキャッシュし、
  // それ以降はキャッシュを返すfactoryコンストラクタ。
  factory FirebaseManager() {
    if (_instance == null) _instance = new FirebaseManager._internal();
    return _instance;
  }

  FirebaseManager._internal() {}

  set user(FirebaseUser user) {
    _user = user;
  }

  FirebaseUser get user {
    return _user;
  }
}
