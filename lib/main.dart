import 'package:flutter/material.dart';
import 'package:hr_huntlng/Screen/HomePage.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'HR HuntLNG',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MainScreen(),
      debugShowCheckedModeBanner: false,
     
    );
  }
}


         