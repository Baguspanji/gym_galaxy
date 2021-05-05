import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:format_indonesia/format_indonesia.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController _nik = new TextEditingController();
  TextEditingController _nama = new TextEditingController();
  TextEditingController _alamat = new TextEditingController();
  TextEditingController _tempatLahir = TextEditingController();
  TextEditingController _dateLahir = TextEditingController();
  TextEditingController _tanggalLahir = TextEditingController();

  TextStyle _style(Color color, double size, FontWeight weight) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }

  void _onAdd(context) async {
    if (_nik.text == "" ||
        _nama.text == "" ||
        _alamat.text == "" ||
        _tempatLahir.text == "" ||
        _tanggalLahir.text == "") {
      showAlertDialog(context);
    } else {
      databaseReference.child("members").push().set({
        'nik': _nik.text,
        'nama': _nama.text,
        'alamat': _alamat.text,
        'tempat_lahir': _tempatLahir.text,
        'tanggal_lahir': _tanggalLahir.text,
      }).then((value) {
        _nik.text = '';
        _nama.text = '';
        _alamat.text = '';
        _tempatLahir.text = '';
        _tanggalLahir.text = '';
        _dateLahir.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            SizedBox(height: 40),
            buildInput(
                size, _nik, Icons.card_membership_outlined, 'Masukkan NIK'),
            buildInput(
                size, _nama, Icons.person_outline_outlined, 'Masukkan Nama'),
            buildInput(size, _alamat, Icons.home_outlined, 'Masukkan Alamat'),
            buildInput(size, _tempatLahir, Icons.home_work_outlined,
                'Masukkan Tempat Lahir'),
            buildDatePicker(size, context, _dateLahir, _tanggalLahir,
                Icons.date_range_outlined, 'Masukkan Tanggal Lahir'),
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
