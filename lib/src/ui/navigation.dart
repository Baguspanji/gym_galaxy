import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:gym/src/ui/absensi.dart';
import 'package:gym/src/ui/home.dart';
import 'package:gym/src/ui/user.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            AbsensiPage(),
            UserPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.black,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            title: Text('Member'),
            icon: Icon(Icons.person_search),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            title: Text('Absensi'),
            icon: Icon(Icons.history),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            title: Text('Profil'),
            icon: Icon(Icons.person),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
