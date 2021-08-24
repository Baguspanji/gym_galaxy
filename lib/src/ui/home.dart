import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:gym_galaxy/src/models/getAbsensi.dart';
import 'package:gym_galaxy/src/models/getMembers.dart';
import 'package:gym_galaxy/src/ui/perpanjangan.dart';
import 'package:gym_galaxy/src/ui/profil.dart';
import 'package:gym_galaxy/src/ui/utils/dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _cariData = new TextEditingController();

  final membersReference = FirebaseDatabase.instance.reference();

  List<GetMembers> _items = List();
  List<GetMembers> _search = List();
  List<GetAbsensi> _absen = List();

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  void dispose() {
    super.dispose();
    _items.clear();
    _search.clear();
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
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    width: size.width * 0.74,
                    child: TextField(
                      controller: _cariData,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.search,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30),
                          ),
                        ),
                        hintText: 'Cari Data',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _onAdd();
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(
                        Icons.add_rounded,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: size.height * 0.73,
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: (_search.length != 0 || _cariData.text.isNotEmpty)
                  ? ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: _search.length,
                      itemBuilder: (context, i) {
                        final cari = _search[i];
                        return Column(
                          children: [
                            buildItems(
                              size,
                              cari.id,
                              cari.nama,
                              cari.alamat,
                              cari.dari,
                              cari.sampai,
                              cari.tipeMember,
                              cari.status,
                              cari.image,
                            ),
                          ],
                        );
                      },
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: _items.length,
                      itemBuilder: (context, i) {
                        final item = _items[i];
                        return Column(
                          children: [
                            buildItems(
                              size,
                              item.id,
                              item.nama,
                              item.alamat,
                              item.dari,
                              item.sampai,
                              item.tipeMember,
                              item.status,
                              item.image,
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

  Container buildItems(Size size, String uid, String nama, String alamat,
      DateTime dari, DateTime sampai, String member, int status, String image) {
    String _dari = (Waktu(dari).yMMMMEEEEd()).toString();
    String _sampai = (Waktu(sampai).yMMMMEEEEd()).toString();
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: size.height * 0.13,
      width: size.width * 0.9,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: status == 1 ? Colors.white : Colors.grey.shade400,
        border: Border.all(
          width: 1,
          color: Colors.blueGrey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          _onUser(context, uid, member, status);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: image == null
                      ? AssetImage('assets/noimage.png')
                      : NetworkImage(image),
                ),
              ),
            ),
            Expanded(
              child: Column(
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
                              size: 14,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 2),
                            Text(
                              _dari,
                              style: _style(
                                Colors.blue,
                                14,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                  sampai == DateTime.parse('0000-00-00')
                      ? Text(
                          '-',
                          style: _style(
                            Colors.redAccent,
                            14,
                            FontWeight.w500,
                          ),
                        )
                      : Row(
                          children: [
                            Icon(
                              Icons.arrow_circle_down,
                              size: 14,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 2),
                            Text(
                              _sampai,
                              style: _style(
                                Colors.redAccent,
                                14,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }

  _onSearch(String value) {
    _search.clear();
    if (value.isEmpty) {
      setState(() {});
      return;
    }

    _items.forEach((e) {
      if (e.nama.toLowerCase().contains(value.toLowerCase()) ||
          e.alamat.toLowerCase().contains(value.toLowerCase())) _search.add(e);
    });
    setState(() {});
  }

  void _onAdd() {
    Navigator.pushNamed(context, '/add');
  }

  void readData() {
    _items.clear();
    _absen.clear();

    membersReference.child("members").onChildAdded.listen(_onMember);

    // membersReference.child("absensi").onChildAdded.listen(_onAbsensi);
  }

  void _onMember(Event event) {
    setState(() {
      _items.add(new GetMembers.fromSnapshot(event.snapshot));
      _items.sort((a, b) => b.status.compareTo(a.status));
      _items.sort((e, f) => f.sampai.compareTo(DateTime.now()));
    });
  }

  void _onAbsensi(Event event) {
    setState(() {
      _absen.add(new GetAbsensi.fromSnapshot(event.snapshot));
    });
  }

  void _onUser(BuildContext context, String uid, String member, int status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          DateTime now = DateTime.now();
          var absen = _absen.where((e) =>
              e.id.contains(uid) &&
              DateFormat('yyyy-MM-dd').format(DateTime.parse(e.tanggal)) ==
                  DateFormat('yyyy-MM-dd').format(now));
          return SimpleDialog(
            title: Text('Pilih Aksi'),
            children: [
              SimpleDialogItem(
                icon: Icons.account_circle_outlined,
                color: Colors.blue,
                text: 'Profil Member',
                onPressed: () {
                  _onProfil(uid);
                },
              ),
              status == 1
                  ? absen.isEmpty
                      ? SimpleDialogItem(
                          icon: Icons.history_rounded,
                          color: Colors.orange,
                          text: 'Absensi Member',
                          onPressed: () {
                            _onAbsen(context, uid);
                          },
                        )
                      : SimpleDialogItem(
                          icon: Icons.history_rounded,
                          color: Colors.orange,
                          text: 'Absensi Member',
                          onPressed: () {
                            Navigator.pop(context);
                            showAlertDialog(
                                context, "Peringatan", "Member sudah absen!");
                          },
                        )
                  : Container(),
              status == 1
                  ? member != 'Pengunjung'
                      ? SimpleDialogItem(
                          icon: Icons.bar_chart_rounded,
                          color: Colors.red,
                          text: 'Perpanjang Member',
                          onPressed: () {
                            _onPerpanjangan(uid);
                          },
                        )
                      : SimpleDialogItem(
                          icon: Icons.bar_chart_rounded,
                          color: Colors.red,
                          text: 'Perpanjang Member',
                          onPressed: () {
                            Navigator.pop(context);
                            showAlertDialog(context, "Peringatan",
                                "Status member masih pengunjung!");
                          },
                        )
                  : Container(),
            ],
          );
        });
  }

  void _onAbsen(BuildContext context, String uid) {
    membersReference
        .child('absensi')
        .orderByChild('tanggal')
        .startAt(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
        .endAt(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
        .onChildAdded
        .listen((e) {
      if (e.snapshot.value['id'] == uid) {
        Navigator.pop(context);
        showAlertDialog(context, "Gagal", "Member sudah absen!");
      } else {
        membersReference.child("absensi").push().set({
          'id': uid,
          'tanggal': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
        }).then((_) {
          readData();
          Navigator.pop(context);
          showAlertDialog(context, "Berhasil", "Berhasil Absensi!");
        });
      }
    });
  }

  void _onProfil(String uid) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfilPage(uid: uid)));
  }

  void _onPerpanjangan(String uid) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PerpanjanganPage(uid: uid)));
  }

  showAlertDialog(BuildContext context, String title, String isi) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        return;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(isi),
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
