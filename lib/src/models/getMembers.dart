import 'package:firebase_database/firebase_database.dart';

class GetMembers {
  String _id;
  String _alamat;
  String _image;
  String _nama;
  DateTime _tanggalLahir;
  String _tempatLahir;
  String _tipeMember;
  int _status;
  DateTime _dari;
  DateTime _sampai;

  GetMembers(
    this._id,
    this._alamat,
    this._image,
    this._nama,
    this._tanggalLahir,
    this._tempatLahir,
    this._tipeMember,
    this._status,
    this._dari,
    this._sampai,
  );

  GetMembers.map(dynamic obj) {
    this._alamat = obj['alamat'];
    this._image = obj['image'];
    this._nama = obj['nama'];
    this._tanggalLahir = obj['tanggal_lahir'];
    this._tempatLahir = obj['tempat_lahir'];
    this._tipeMember = obj['tipe_member'];
    this._status = obj['status'];
    this._dari =
        obj['member']['dari'] != '' ? obj['member']['dari'] : '0000-00-00';
    this._sampai =
        obj['member']['sampai'] != '' ? obj['member']['sampai'] : '0000-00-00';
  }

  String get id => _id;
  String get alamat => _alamat;
  String get image => _image;
  String get nama => _nama;
  DateTime get tanggalLahir => _tanggalLahir;
  String get tempatLahir => _tempatLahir;
  String get tipeMember => _tipeMember;
  int get status => _status;
  DateTime get dari => _dari;
  DateTime get sampai => _sampai;

  GetMembers.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _alamat = snapshot.value['alamat'];
    _image = snapshot.value['image'];
    _nama = snapshot.value['nama'];
    _tanggalLahir = DateTime.parse(snapshot.value['tanggal_lahir']);
    _tempatLahir = snapshot.value['tempat_lahir'];
    _tipeMember = snapshot.value['tipe_member'];
    _status = snapshot.value['status'];
    _dari = DateTime.parse(snapshot.value['member']['dari'] != ''
        ? snapshot.value['member']['dari']
        : '0000-00-00');
    _sampai = DateTime.parse(snapshot.value['member']['sampai'] != ''
        ? snapshot.value['member']['sampai']
        : '0000-00-00');
  }
}
