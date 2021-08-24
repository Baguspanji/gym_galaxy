import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:gym_galaxy/src/models/getAbsensi.dart';
import 'package:gym_galaxy/src/models/getMembers.dart';

class AbsensiPage extends StatefulWidget {
  AbsensiPage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AbsensiPage> {
  final membersReference = FirebaseDatabase.instance.reference();

  TextEditingController _dateLahir = TextEditingController();
  TextEditingController _tanggalLahir = TextEditingController();

  List<GetMembers> _items = List();
  List<GetAbsensi> _absen = List();
  List<GetAbsensi> _list = List();

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  void dispose() {
    super.dispose();
    _items.clear();
    _absen.clear();
  }

  TextStyle _style(Color color, double size, FontWeight weight) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Gym Galaxy'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.date_range, size: 30),
            onPressed: () {
              pickDate();
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: size.height * 0.8,
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: _absen.length,
                itemBuilder: (context, i) {
                  final absen = _absen[i];
                  final item = _items.where((e) => e.id == absen.id);
                  return Column(
                    children: [
                      buildItems(
                        size,
                        item.first.id,
                        item.first.nama,
                        item.first.alamat,
                        absen.tanggal,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildItems(
      Size size, String uid, String nama, String alamat, String now) {
    String _now = (Waktu(DateTime.parse(now)).yMMMMEEEEd()).toString();
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: size.height * 0.13,
      width: size.width * 0.9,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.blueGrey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                nama,
                style: _style(
                  Colors.black,
                  21,
                  FontWeight.w500,
                ),
              ),
              Text(
                alamat,
                style: _style(
                  Colors.black,
                  14,
                  FontWeight.w300,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _now,
                style: _style(
                  Colors.grey[600],
                  14,
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pickDate() async {
    DateTime date = DateTime(1900);
    FocusScope.of(context).requestFocus(new FocusNode());

    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      _absen.clear();
      membersReference
          .child("absensi")
          .orderByChild('tanggal')
          .startAt(formattedDate)
          .endAt(formattedDate)
          .onChildAdded
          .listen(_onAbsensi);
    }
  }

  void readData() {
    _items.clear();
    _absen.clear();

    membersReference.child("members").onChildAdded.listen(_onMember);

    membersReference
        .child("absensi")
        .orderByChild('tanggal')
        .startAt(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
        .endAt(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
        .onChildAdded
        .listen(_onAbsensi);
  }

  void _onMember(Event event) {
    setState(() {
      _items.add(new GetMembers.fromSnapshot(event.snapshot));
    });
  }

  void _onAbsensi(Event event) async {
    setState(() {
      _absen.add(new GetAbsensi.fromSnapshot(event.snapshot));
      _absen.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    });
  }
}
