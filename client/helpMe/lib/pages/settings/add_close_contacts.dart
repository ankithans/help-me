import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/models/close_contacts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class AddCloseContacts extends StatefulWidget {
  @override
  _AddCloseContactsState createState() => _AddCloseContactsState();
}

class _AddCloseContactsState extends State<AddCloseContacts> {
  final _nameController = new TextEditingController();
  final _phoneController = new TextEditingController();
  bool hasData = false;

  _onAlertWithCustomContentPressed(context) {
    Alert(
        style: AlertStyle(
          backgroundColor: backgroundColor,
          alertBorder: Border.all(),
          titleStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        context: context,
        title: "Add contact",
        content: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.account_circle, color: Colors.white),
                labelText: 'name',
              ),
            ),
            TextField(
              controller: _phoneController,
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
          loading
              ? CircularProgressIndicator()
              : DialogButton(
                  color: backgroundColor,
                  border: Border.all(color: primaryColor),
                  onPressed: () {
                    if (_nameController.text == "" ||
                        _phoneController.text == "")
                      Fluttertoast.showToast(msg: "PLease Enter the details");
                    else {
                      setState(() {
                        postLoading = true;
                      });
                      postCloseContact();
                      setState(() {
                        postLoading = true;
                      });
                    }
                  },
                  child: Text(
                    "Add Number",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
        ]).show();
  }

  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  CloseContacts closeContacts;
  bool loading = false;
  bool postLoading = false;
  Future<CloseContacts> getCloseContact() async {
    String token = await secureStorage.read(key: "token");
    try {
      var response =
          await http.get(api + "/api/v1/users/getCloseContact", headers: {
        "x-auth-token": token,
      });
      if (json.decode(response.body)["success"] == false) {
        hasData = false;
      } else {
        hasData = true;
      }

      print(response.body);
      return CloseContacts.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e);
      return e;
    }
  }

  void postCloseContact() async {
    Map<String, int> closeContacts = {};
    closeContacts[_nameController.text.toString()] =
        int.parse(_phoneController.text);
    print(closeContacts);
    String token = await secureStorage.read(key: "token");
    try {
      var response = await http.post(
        api + "/api/v1/users/addCloseContact",
        headers: {
          "x-auth-token": token,
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({"closeContacts": closeContacts}),
      );
      print(response.body);
      Fluttertoast.showToast(msg: "phone number added successfully");
      Navigator.pop(context);
      maptoCloseContacts();
    } catch (e) {
      print(e);
    }
  }

  maptoCloseContacts() async {
    setState(() {
      loading = true;
    });
    closeContacts = await getCloseContact();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    maptoCloseContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Close Contacts'),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                !hasData
                    ? Container()
                    : SizedBox(
                        height: 400,
                        child: ListView.builder(
                          itemCount: closeContacts.phoneNumbers.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {},
                              leading: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              // trailing: Text(
                              //   "${closeContacts.phoneNumbers[index]}",
                              //   style: TextStyle(
                              //     color: primaryColor,
                              //   ),
                              // ),
                              title: Text(
                                "${closeContacts.phoneNumbers[index]}",
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
