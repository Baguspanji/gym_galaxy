import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:gym_galaxy/firebase/storage.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends StatefulWidget {
  AddUser({Key key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController _email = new TextEditingController();

  TextStyle _style(Color color, double size, FontWeight weight) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }

  void _onAdd(context) async {
    if (_email.text == "") {
      showAlertDialog(context);
    } else {
      databaseReference.child("users").push().set(
        {'email': _email.text, 'role': 'user'},
      ).then((value) {
        Navigator.of(context).pop();
      });
    }
    // print(_tanggalDari.text);
    // print(_tanggalSampai.text);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 80),
            Text(
              'Tambah Data User',
              style: _style(
                Colors.black,
                28,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            buildInput(
                size, _email, Icons.person_outline_outlined, 'Masukkan Email'),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                _onAdd(context);
              },
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(
                      width: 1,
                      color: Colors.black54,
                    ),
                    borderRadius: BorderRadius.circular(18)),
                child: Text(
                  "Simpan",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: Border.all(
                      width: 1,
                      color: Colors.black54,
                    ),
                    borderRadius: BorderRadius.circular(18)),
                child: Text(
                  "Kembali",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildInput(
    Size size,
    TextEditingController controller,
    IconData icon,
    String placeholder,
  ) {
    return Container(
      width: size.width * 0.8,
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          icon: Icon(icon),
          border: OutlineInputBorder(),
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        return;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Peringatan"),
      content: Text("Form Tidak boleh kosong!"),
      // actions: [
      //   okButton,
      // ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
