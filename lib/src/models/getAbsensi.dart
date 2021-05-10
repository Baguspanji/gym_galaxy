import 'package:firebase_database/firebase_database.dart';

class GetAbsensi {
  String _uid;
  String _id;
  DateTime _tanggal;

  GetAbsensi(
    this._uid,
    this._id,
    this._tanggal,
  );

  GetAbsensi.map(dynamic obj) {
    this._id = obj['id'];
    this._tanggal = obj['tanggal'];
  }

  String get uid => _uid;
  String get id => _id;
  DateTime get tanggal => _tanggal;

  GetAbsensi.fromSnapshot(DataSnapshot snapshot) {
    _uid = snapshot.key;
    _id = snapshot.value['id'];
    _tanggal = DateTime.parse(snapshot.value['tanggal']);
  }
}
