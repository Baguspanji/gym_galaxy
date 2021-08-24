import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gym_galaxy/src/models/getUsers.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_galaxy/src/shared/preference.dart';
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
      await setNama(user.displayName);
      await setEmail(user.email);
      await setFoto(user.photoURL);
      _users.forEach((e) async {
        if (e.email.contains(user.email)) {
          isUserSignedIn = true;
          await setRole(e.role);
        }
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
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.7,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                _onLogin();
              },
              child: Container(
                width: size.width * 0.6,
                height: size.height * 0.06,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white38,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/google.png'),
                    Text(
                      "Sign In Google",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
