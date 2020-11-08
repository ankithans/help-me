import 'package:flutter/material.dart';
import 'package:helpMe/constants.dart';

class HardwareButtons extends StatefulWidget {
  @override
  _HardwareButtonsState createState() => _HardwareButtonsState();
}

class _HardwareButtonsState extends State<HardwareButtons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Hardware Buttons'),
      body: Column(
        children: [],
      ),
    );
  }
}
