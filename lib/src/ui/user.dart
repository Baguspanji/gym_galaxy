import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_galaxy/src/shared/preference.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _user = '';
  String _nama = '';
  String _email = '';
  String _foto = '';

  TextStyle _style(Color color, double size, FontWeight weight) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }

  _readData() {
    setState(() {
      getNama().then((value) {
        print('nama : $value');
        _nama = value;
      });
      getEmail().then((value) => _email = value);
      getFoto().then((value) => _foto = value);
    });
  }

  @override
  void initState() {
    super.initState();
    _readData();
  }

  void _onSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacementNamed(context, '/login');
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
            Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(160),
                image: DecorationImage(
                    image: NetworkImage(_foto == ''
                        ? 'https://icons.iconarchive.com/icons/goescat/macaron/256/gimp-icon.png'
                        : _foto),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _nama,
              style: _style(
                Colors.black,
                28.0,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _email,
              style: _style(
                Colors.black,
                26.0,
                FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _onSignOut();
              },
              child: Container(
                width: size.width * 0.46,
                height: size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(18)),
                child: Text(
                  "Sign Out Google",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
