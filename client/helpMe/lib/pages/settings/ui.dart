import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/auth/signup/verify_phone.dart';
import './add_close_contacts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Settings'),
      body: ListView(
        children: [
          // ListTile(
          //   leading: Icon(
          //     Icons.info_outline,
          //     color: fontColor,
          //   ),
          //   title: Text('Report', style: Theme.of(context).textTheme.bodyText1),
          // ),
          ListTile(
            leading: Icon(
              Icons.hardware,
              color: fontColor,
            ),
            title: Text(
              'Map Hardware Button',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCloseContacts(),
                ),
              );
            },
            leading: Icon(
              Icons.people,
              color: fontColor,
            ),
            title: Text(
              'Add Close Contacts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            onTap: () async {
              await secureStorage.delete(key: "token");
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyPhone(),
                ),
              );
            },
            leading: Icon(
              Icons.logout,
              color: fontColor,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
