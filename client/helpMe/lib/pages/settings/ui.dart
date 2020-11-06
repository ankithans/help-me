import 'package:flutter/material.dart';
import 'package:helpMe/constants.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Settings'),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline, color: fontColor,),
            title: Text('Report', style: Theme.of(context).textTheme.bodyText1),
          ),
          ListTile(
            leading: Icon(Icons.hardware, color: fontColor,),
            title: Text('Map Hardware Button', style: Theme.of(context).textTheme.bodyText1,),
          )
        ],
      ),
    );
  }
}