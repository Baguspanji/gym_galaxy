import 'package:firebase_database/firebase_database.dart';

class GetUsers {
  String _uid;
  String _email;
  String _role;

  GetUsers(
    this._uid,
    this._email,
    this._role,
  );

  GetUsers.map(dynamic obj) {
    this._email = obj['email'];
    this._role = obj['role'];
  }

  String get uid => _uid;
  String get email => _email;
  String get role => _role;

  GetUsers.fromSnapshot(DataSnapshot snapshot) {
    _uid = snapshot.key;
    _email = snapshot.value['email'];
    _role = snapshot.value['role'];
  }
}
