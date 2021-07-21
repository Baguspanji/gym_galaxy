import 'package:firebase_database/firebase_database.dart';

class GetUsers {
  String _uid;
  String _email;

  GetUsers(
    this._uid,
    this._email,
  );

  GetUsers.map(dynamic obj) {
    this._email = obj['email'];
  }

  String get uid => _uid;
  String get email => _email;

  GetUsers.fromSnapshot(DataSnapshot snapshot) {
    _uid = snapshot.key;
    _email = snapshot.value['email'];
  }
}
