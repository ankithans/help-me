import 'dart:async';
import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/settings/ui.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool enabled = true;

  void sendNotifications() async {
    String token = await secureStorage.read(key: "token");
    Map data = {};
    String longitude = await secureStorage.read(key: "longitude");
    String latitude = await secureStorage.read(key: "latitude");
    data["longitude"] = longitude;
    data["latitude"] = latitude;
    data["distance"] = 1000;
    try {
      var response = await http.post(
        api + "/api/v1/location/users",
        headers: {
          "x-auth-token": token,
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );
      print(response.body);
      if (json.decode(response.body)["success"] == true) {
        Fluttertoast.showToast(msg: "Notifications and sms sent successfully");
        setState(() {
          enabled = false;
          Timer(Duration(seconds: 10), () {
            setState(() {
              enabled = true;
            });
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(
        context,
        title: 'Help Me',
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(),
                  ),
                );
              }),
        ],
      ),
      body: Center(
        child: RaisedButton(
          onPressed: enabled ? sendNotifications : null,
          color: primaryColor,
          child: Container(
            height: 160.0,
            width: 140.0,
            decoration: BoxDecoration(),
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
