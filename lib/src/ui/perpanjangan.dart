import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gym/src/models/getMembers.dart';
import 'package:intl/intl.dart';

class PerpanjanganPage extends StatefulWidget {
  final String uid;

  const PerpanjanganPage({Key? key, required this.uid}) : super(key: key);

  @override
  _PerpanjanganPageState createState() => _PerpanjanganPageState();
}

class _PerpanjanganPageState extends State<PerpanjanganPage> {
  final membersReference =
      FirebaseDatabase.instance.reference().child('members');

  List items = [];
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

  @override
  void initState() {
    readData();
    super.initState();
  }

  void readData() {
    membersReference.child(widget.uid).once().then((value) {
      // items.add(new GetMembers.fromSnapshot(value));

      _tanggalDari.text = items[0].dari != DateTime.parse('0000-00-00')
          ? (items[0].dari).toString()
          : '';
      _tanggalSampai.text = items[0].sampai != DateTime.parse('0000-00-00')
          ? (items[0].sampai).toString()
          : '';
      _dateDari.text = items[0].dari;
      _dateSampai.text = items[0].sampai;
    });
  }

  void _onUpdate(context) async {
    if (_tanggalDari.text == "" || _tanggalSampai.text == "") {
      showAlertDialog(context);
    } else {
      membersReference.child(widget.uid).update({
        'member': {
          'dari': _tanggalDari.text,
          'sampai': _tanggalSampai.text,
        }
      }).then((value) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
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
              'Perpanjang Member',
              style: _style(
                Colors.black,
                28,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            buildDatePicker(size, context, _dateDari, _tanggalDari,
                Icons.date_range_outlined, 'Member dari tanggal'),
            buildDatePicker(size, context, _dateSampai, _tanggalSampai,
                Icons.date_range_outlined, 'Member sampai tanggal'),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _onUpdate(context);
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
                  "Update",
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

          DateTime? now = DateTime.now();

          date = (await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: now,
            lastDate: now,
          ))!;

          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          dateController.text = formattedDate;
          DateTime datetime = DateTime.parse(formattedDate);
          controller.text = datetime.toString();
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
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
