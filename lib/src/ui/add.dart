import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:gym_galaxy/firebase/storage.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  String imageUrl;

  TextEditingController _nama = new TextEditingController();
  TextEditingController _alamat = new TextEditingController();
  TextEditingController _tempatLahir = TextEditingController();
  TextEditingController _dateLahir = TextEditingController();
  TextEditingController _tanggalLahir = TextEditingController();
  TextEditingController _dateDari = TextEditingController();
  TextEditingController _tanggalDari = TextEditingController();
  TextEditingController _dateSampai = TextEditingController();
  TextEditingController _tanggalSampai = TextEditingController();

  TextStyle _style(Color color, double size, FontWeight weight) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }

  void _onAdd(context) async {
    if (_nama.text == "" ||
        _alamat.text == "" ||
        _tempatLahir.text == "" ||
        _tanggalLahir.text == "" ||
        _dropdownValue == 'Pilih Member') {
      showAlertDialog(context);
    } else {
      if (_dropdownValue != 'Pengunjung' &&
          _tanggalDari.text == '' &&
          _tanggalSampai.text == '') {
        showAlertDialog(context);
      } else {
        databaseReference.child("members").push().set({
          'image': imageUrl,
          'nama': _nama.text,
          'alamat': _alamat.text,
          'tempat_lahir': _tempatLahir.text,
          'tanggal_lahir': _tanggalLahir.text,
          'tipe_member': _dropdownValue,
          'status': 1,
          'member': {
            'dari': _tanggalDari.text,
            'sampai': _tanggalSampai.text,
          }
        }).then((value) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    }
    // print(_tanggalDari.text);
    // print(_tanggalSampai.text);
  }

  Future<void> getImage(bool select) async {
    ImagePicker _picker = ImagePicker();
    PickedFile image;

    if (select) {
      image = await _picker.getImage(source: ImageSource.camera);
    } else {
      image = await _picker.getImage(source: ImageSource.gallery);
    }

    imageUrl = await storage.uploadImage(image);

    setState(() {});
  }

  String _dropdownValue = 'Pilih Member';

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
              'Tambah Data Member',
              style: _style(
                Colors.black,
                28,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.width * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                image: DecorationImage(
                  image: imageUrl == null
                      ? AssetImage('assets/noimage.png')
                      : NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 2.0),
                width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      getImage(false);
                    },
                    child: Text(
                      'Upload Gambar',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            buildInput(
                size, _nama, Icons.person_outline_outlined, 'Masukkan Nama'),
            buildInput(size, _alamat, Icons.home_outlined, 'Masukkan Alamat'),
            buildInput(size, _tempatLahir, Icons.home_work_outlined,
                'Masukkan Tempat Lahir'),
            buildDatePicker(size, context, _dateLahir, _tanggalLahir,
                Icons.date_range_outlined, 'Masukkan Tanggal Lahir'),
            buildDropdown(size),
            buildMember(context, size),
            SizedBox(height: 20),
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
                Navigator.pushReplacementNamed(context, '/home');
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

  Widget buildMember(BuildContext context, Size size) {
    if (_dropdownValue == 'Member Mingguan' ||
        _dropdownValue == 'Member Bulanan') {
      return Column(
        children: [
          buildDatePicker(size, context, _dateDari, _tanggalDari,
              Icons.date_range_outlined, 'Member dari tanggal'),
          buildDatePicker(size, context, _dateSampai, _tanggalSampai,
              Icons.date_range_outlined, 'Member sampai tanggal')
        ],
      );
    } else {
      return SizedBox(height: 2);
    }
  }

  Container buildDropdown(Size size) {
    return Container(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.card_membership_outlined,
            color: Colors.grey[500],
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.7,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey[500]),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: _dropdownValue,
              elevation: 16,
              style: const TextStyle(color: Colors.grey),
              onChanged: (String newValue) {
                setState(() {
                  _dropdownValue = newValue;
                });
              },
              items: <String>[
                'Pilih Member',
                'Pengunjung',
                'Member Mingguan',
                'Member Bulanan'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: size.width * 0.6,
                    child: Text(
                      value,
                      style: _style(
                        Colors.grey[500],
                        16,
                        FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDatePicker(
    Size size,
    BuildContext context,
    TextEditingController controller,
    TextEditingController dateController,
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
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());

          date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          dateController.text = formattedDate;
          DateTime datetime = DateTime.parse(formattedDate);
          controller.text = Waktu(datetime).yMMMMEEEEd();
        },
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
