import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/models/register.dart';
import 'package:helpMe/pages/auth/login/login.dart';
import 'package:helpMe/pages/home/ui.dart';
import 'package:helpMe/widgets/text_box.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

//import 'package:helpMe/pages/auth/signup/services.dart';
class SignUpPage extends StatefulWidget {
  final String phone;

  const SignUpPage({Key key, this.phone}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = new TextEditingController();
  final _addressController = new TextEditingController();
  bool loading = false;
  Map data = {};
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future getData() async {
    String longitude = await secureStorage.read(key: "longitude");
    String latitude = await secureStorage.read(key: "latitude");
    String fcmToken = await secureStorage.read(key: "fcmToken");

    data["name"] = _nameController.text;
    data["phone"] = widget.phone;
    data["location"] = {
      "type": "Point",
      "coordinates": [longitude, latitude],
    };
    data["address"] = _addressController.text;
    data["fcmToken"] = fcmToken;
    print(data);
  }

  Future<Register> register() async {
    try {
      await getData();
      setState(() {
        loading = true;
      });
      var response = await http.post(
        api + "/api/v1/users/register",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );
      print(response.body);
      if (json.decode(response.body)["success"] == false) {
        Fluttertoast.showToast(msg: json.decode(response.body)["error"]);
      }
      setState(() {
        loading = false;
      });
      String token = json.decode(response.body)["token"];
      print(token);
      await secureStorage.write(key: "token", value: token);
      if (json.decode(response.body)["success"] == true) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
      return Register.fromJson(json.decode(response.body));
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            TextBoxEmailPhone(
              enabled: true,
              hintText: "Enter your name",
              labelText: "Phone",
              textEditingController: _nameController,
              obscureText: false,
              textInputType: TextInputType.text,
            ),
            SizedBox(
              height: 15,
            ),
            TextBoxEmailPhone(
              enabled: true,
              hintText: "Enter your address",
              labelText: "Phone",
              textEditingController: _addressController,
              obscureText: false,
              textInputType: TextInputType.text,
            ),
            SizedBox(
              height: 5,
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: RaisedButton(
                      child: Text('Sign Up'),
                      onPressed: () async {
                        if (_nameController.text == "" ||
                            _addressController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Please Enter the above details");
                        } else {
                          await register();
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: primaryColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
