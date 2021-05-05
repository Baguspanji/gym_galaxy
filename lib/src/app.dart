import 'package:flutter/material.dart';
import 'package:gym_galaxy/src/ui/add.dart';
import 'package:gym_galaxy/src/ui/login.dart';
import 'package:gym_galaxy/src/ui/navigation.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/add': (context) => AddPage(),
        '/home': (context) => Navbar(),
      },
    );
  }
}
