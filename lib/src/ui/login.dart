import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gym_galaxy/src/models/getUsers.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_galaxy/src/ui/navigation.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final membersReference = FirebaseDatabase.instance.reference();

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  bool isUserSignedIn = false;
  List _users = List();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
    _readUser();
  }

  _readUser() {
    membersReference.child("users").onChildAdded.listen((event) {
      setState(() {
        _users.add(new GetUsers.fromSnapshot(event.snapshot));
      });
    });
  }

  void _cekSignIn() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      _users.forEach((e) {
        if (e.email.contains(user.email)) isUserSignedIn = true;
      });
      if (isUserSignedIn) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Navbar()));
      } else {
        _signOut().then((value) => showAlertDialog(context));
        print('User is currently signed out!');
      }
    });
  }

  Future<Null> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
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
      content: Text("User tidak terdaftar!"),
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

  void _onLogin() {
    signInWithGoogle().then((value) => {_cekSignIn()});
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
            SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                _onLogin();
              },
              child: Container(
                width: size.width * 0.4,
                height: size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(18)),
                child: Text(
                  "Sign In Google",
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
