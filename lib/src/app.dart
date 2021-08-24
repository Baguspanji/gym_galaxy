import 'package:flutter/material.dart';
import 'package:gym_galaxy/src/ui/add.dart';
import 'package:gym_galaxy/src/ui/login.dart';
import 'package:gym_galaxy/src/ui/navigation.dart';
import 'package:gym_galaxy/src/ui/splashScreen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Galaxy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/add': (context) => AddPage(),
        '/home': (context) => Navbar(),
      },
    );
  }
}
