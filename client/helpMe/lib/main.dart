import 'package:flutter/material.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/auth/login/ui.dart';
import 'package:helpMe/pages/home/ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'Nunito',
            color: primaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
          bodyText1: TextStyle(
            fontFamily: 'Nunito',
            color: fontColor,
            fontSize: 15.0
          )
        )
      ),
      home: LoginPage(),
    );
  }
}