import 'package:firebase_database/firebase_database.dart';

class GetMembers {
  String _id;
  String _alamat;
  String _nama;
  String _nik;
  DateTime _tanggalLahir;
  String _tempatLahir;

  GetMembers(
    this._id,
    this._alamat,
    this._nama,
    this._nik,
    this._tanggalLahir,
    this._tempatLahir,
  );

  GetMembers.map(dynamic obj) {
    this._alamat = obj['alamat'];
    this._nama = obj['nama'];
    this._nik = obj['nik'];
    this._tanggalLahir = obj['tanggal_lahir'];
    this._tempatLahir = obj['tempat_lahir'];
  }

  String get id => _id;
  String get alamat => _alamat;
  String get nama => _nama;
  String get nik => _nik;
  DateTime get tanggalLahir => _tanggalLahir;
  String get tempatLahir => _tempatLahir;

  GetMembers.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _alamat = snapshot.value['alamat'];
    _nama = snapshot.value['nama'];
    _nik = snapshot.value['nik'];
    _tanggalLahir = DateTime.parse(snapshot.value['tanggal_lahir']);
    _tempatLahir = snapshot.value['tempat_lahir'];
  }
}
