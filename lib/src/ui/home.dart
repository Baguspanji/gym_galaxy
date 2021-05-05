import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gym_galaxy/src/models/getMembers.dart';
import 'package:gym_galaxy/src/ui/edit.dart';
import 'package:gym_galaxy/src/ui/profil.dart';
import 'package:gym_galaxy/src/ui/utils/dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _cariData = new TextEditingController();

  final membersReference =
      FirebaseDatabase.instance.reference().child('members');

  List items = List();
  StreamSubscription _onMemberSubscription;

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  void dispose() {
    _onMemberSubscription.cancel();
    super.dispose();
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[100],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "Gym Galaxy Pasuruan",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
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
                      onSubmitted: (value) {
                        _onSearch();
                      },
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
              height: size.height * 0.71,
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      buildItems(size, items[index].id, items[index].nama,
                          items[index].alamat),
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

  Container buildItems(Size size, String uid, String nama, String alamat) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: size.height * 0.1,
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
      child: InkWell(
        onTap: () {
          _onUser(context, uid);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  alamat,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }

  void _onSearch() {
    items.clear();
    membersReference
        .orderByChild("nama")
        .startAt(_cariData.text)
        .onChildAdded
        .listen(_onMember);
    ;
  }

  void _onUser(context, String uid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
              SimpleDialogItem(
                icon: Icons.history_rounded,
                color: Colors.orange,
                text: 'Absensi Member',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SimpleDialogItem(
                icon: Icons.bar_chart_rounded,
                color: Colors.red,
                text: 'Perpanjang Member',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _onAdd() {
    Navigator.pushNamed(context, '/add');
  }

  void readData() {
    _onMemberSubscription = membersReference.onChildAdded.listen(_onMember);
  }

  void _onMember(Event event) {
    setState(() {
      items.add(new GetMembers.fromSnapshot(event.snapshot));
    });
  }

  void _onEdit(String uid) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditPage(uid: uid)));
  }

  void _onDelete(String uid) {
    membersReference.child(uid).remove();
    items.clear();
    readData();
    Navigator.pop(context);
  }

  void _onProfil(String uid) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfilPage(uid: uid)));
  }
}
