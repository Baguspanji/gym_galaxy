import 'package:firebase_database/firebase_database.dart';

class GetMembers {
  String? _id;
  String? _alamat;
  String? _image;
  String? _nama;
  String? _tanggalLahir;
  String? _tempatLahir;
  String? _tipeMember;
  int? _status;
  String? _dari;
  String? _sampai;

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

  String get id => _id!;
  String get alamat => _alamat!;
  String get image => _image!;
  String get nama => _nama!;
  String get tanggalLahir => _tanggalLahir!;
  String get tempatLahir => _tempatLahir!;
  String get tipeMember => _tipeMember!;
  int get status => _status!;
  String get dari => _dari!;
  String get sampai => _sampai!;

  GetMembers.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _alamat = (snapshot.value as dynamic)['alamat'];
    _image = (snapshot.value as dynamic)['image'];
    _nama = (snapshot.value as dynamic)['nama'];
    _tanggalLahir = (snapshot.value as dynamic)['tanggal_lahir'];
    _tempatLahir = (snapshot.value as dynamic)['tempat_lahir'];
    _tipeMember = (snapshot.value as dynamic)['tipe_member'];
    _status = (snapshot.value as dynamic)['status'];
    _dari = (snapshot.value as dynamic)['member']['dari'];
    _sampai = (snapshot.value as dynamic)['member']['sampai'];
  }
}
