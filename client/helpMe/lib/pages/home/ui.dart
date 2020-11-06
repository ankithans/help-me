import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/settings/ui.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(
        context, 
        title: 'Help Me', 
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: primaryColor,), 
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => SettingsPage()));
            }
          ),
        ],
      ),
      body: Center(
        child: RaisedButton(
          onPressed: (){},
          color: backgroundColor,
          child: Container(
            height: 200.0,
            width: 200.0,
            decoration: BoxDecoration(
              
            ),
            child: FlareActor(
              'assets/images/alarm.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'Alarm',
            ),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }
}