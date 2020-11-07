import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';

class AddCloseContacts extends StatefulWidget {
  @override
  _AddCloseContactsState createState() => _AddCloseContactsState();
}

class _AddCloseContactsState extends State<AddCloseContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Close Contacts'),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          DialogButton(
            color: backgroundColor,
            border: Border.all(color: primaryColor),
            onPressed: () => _onAlertWithCustomContentPressed(context),
            child: Text(
              "Add Number",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  trailing: Text(
                    "9998897668",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                  title: Text(
                    "Ankit",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

_onAlertWithCustomContentPressed(context) {
  Alert(
      style: AlertStyle(
        backgroundColor: backgroundColor,
        alertBorder: Border.all(),
        titleStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      context: context,
      title: "LOGIN",
      content: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.account_circle, color: Colors.white),
              labelText: 'name',
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.phone, color: Colors.white),
              labelText: 'Phone',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: backgroundColor,
          border: Border.all(color: primaryColor),
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Add Number",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}
