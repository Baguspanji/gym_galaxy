import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:gym_galaxy/src/models/getMembers.dart';

import 'edit.dart';

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
  String _nama = '';
  String _alamat = '';
  String _tempatLahir = '';
  String _tanggalLahir = '';
  String _tipeMember = '';
  String _dari = '';
  String _sampai = '';
  int _status = 0;
  DateTime dari = DateTime.parse('0000-00-00');
  DateTime sampai = DateTime.parse('0000-00-00');

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

      _nama = items[0].nama;
      _alamat = items[0].alamat;
      _tipeMember = items[0].tipeMember;
      _status = items[0].status;
      _tempatLahir = items[0].tempatLahir;
      dari = items[0].dari;
      sampai = items[0].sampai;
      _dari = (Waktu(items[0].dari).yMMMMEEEEd()).toString();
      _sampai = (Waktu(items[0].sampai).yMMMMEEEEd()).toString();

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
      backgroundColor: Colors.grey[100],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1),
                  ),
                  child: Text(
                    _nama,
                    style: _style(
                      Colors.black,
                      20.0,
                      FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1),
                  ),
                  child: Text(
                    _alamat,
                    style: _style(
                      Colors.black,
                      20.0,
                      FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1),
                  ),
                  child: Text(
                    '${_tipeMember}',
                    style: _style(
                      Colors.black,
                      20.0,
                      FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1),
                  ),
                  child: Text(
                    '${_tempatLahir}, ${_tanggalLahir}',
                    style: _style(
                      Colors.black,
                      16.0,
                      FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  width: size.width * 0.8,
                  height: size.height * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dari == DateTime.parse('0000-00-00')
                          ? Text(
                              '-',
                              style: _style(
                                Colors.blue,
                                14,
                                FontWeight.w500,
                              ),
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.arrow_circle_up,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  _dari,
                                  style: _style(
                                    Colors.blue,
                                    18,
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 6),
                      sampai == DateTime.parse('0000-00-00')
                          ? Text(
                              '-',
                              style: _style(
                                Colors.redAccent,
                                18,
                                FontWeight.w500,
                              ),
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.arrow_circle_down,
                                  size: 18,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  _sampai,
                                  style: _style(
                                    Colors.redAccent,
                                    18,
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    _onEdit();
                  },
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        border: Border.all(
                          width: 1,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text(
                          "Edit",
                          style: _style(
                            Colors.black,
                            20.0,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _onStatus(widget.uid);
                  },
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: _status == 1
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        border: Border.all(
                          width: 1,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_status == 1
                            ? Icons.person_add_disabled_outlined
                            : Icons.person_add),
                        SizedBox(width: 10),
                        Text(
                          _status == 1 ? "Non-aktifkan" : "Aktifkan",
                          style: _style(
                            _status == 1 ? Colors.white : Colors.black,
                            20.0,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onEdit() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditPage(uid: widget.uid)));
  }

  void _onStatus(String uid) {
    membersReference
        .child(uid)
        .update({'status': _status == 1 ? 0 : 1}).then((value) {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }
}
