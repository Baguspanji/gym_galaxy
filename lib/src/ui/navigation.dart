import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:gym_galaxy/src/ui/home.dart';
import 'package:gym_galaxy/src/ui/user.dart';

class Navbar extends StatefulWidget {
  Navbar({Key key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            HomePage(),
            UserPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.white,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Colors.grey,
            inactiveColor: Colors.grey,
            title: Text('Member'),
            icon: Icon(Icons.person_search),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            activeColor: Colors.grey,
            inactiveColor: Colors.grey,
            title: Text('Absensi'),
            icon: Icon(Icons.history),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            activeColor: Colors.grey,
            inactiveColor: Colors.grey,
            title: Text('Profil'),
            icon: Icon(Icons.person),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
