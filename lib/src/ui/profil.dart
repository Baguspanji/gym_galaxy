import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:gym_galaxy/src/models/getMembers.dart';

class ProfilPage extends StatefulWidget {
  final String uid;
  ProfilPage({Key key, this.uid}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final membersReference =
      FirebaseDatabase.instance.reference().child('members');

  List items = List();
  String _nik = '';
  String _nama = '';
  String _alamat = '';
  String _tempatLahir = '';
  String _tanggalLahir = '';

  TextStyle _style(Color color, double size, FontWeight weight) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }

  void _readData() {
    membersReference.child(widget.uid).once().then((value) {
      items.add(new GetMembers.fromSnapshot(value));

      _nik = items[0].nik;
      _nama = items[0].nama;
      _alamat = items[0].alamat;
      _tempatLahir = items[0].tempatLahir;

      // DateTime datetime = DateTime.parse(items[0].tanggalLahir);
      _tanggalLahir = (Waktu(items[0].tanggalLahir).yMMMMEEEEd()).toString();
      setState(() {});
    });
  }

  @override
  void initState() {
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _nama,
              style: _style(
                Colors.black,
                20.0,
                FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _alamat,
              style: _style(
                Colors.black,
                20.0,
                FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${_tempatLahir} , ${_tanggalLahir}',
              style: _style(
                Colors.black,
                20.0,
                FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
