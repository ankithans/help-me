import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/models/register.dart';
import 'package:helpMe/models/verify_phone.dart';
import 'package:helpMe/pages/auth/signup/signup.dart';
import 'package:helpMe/pages/home/ui.dart';
import 'package:helpMe/widgets/text_box.dart';
import 'package:http/http.dart' as http;

//import 'package:helpMe/pages/auth/signup/services.dart';
class Login extends StatefulWidget {
  final String phone;

  const Login({Key key, this.phone}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneController = new TextEditingController();
  final _otpController = new TextEditingController();
  bool showOtpTextBox = false;
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool loading = false;
  Map data = {};

  Future getData() async {
    String longitude = await secureStorage.read(key: "longitude");
    String latitude = await secureStorage.read(key: "latitude");
    String fcmToken = await secureStorage.read(key: "fcmToken");

    data["phone"] = _phoneController.text;
    data["location"] = {
      "type": "Point",
      "coordinates": [longitude, latitude],
    };
    data["fcmToken"] = fcmToken;
    print(data);
  }

  Future<VerifyMobile> verifyPhone() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await http.post(
        api + "/api/v1/users/verify",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({"phone": _phoneController.text}),
      );
      print(response.body);
      Fluttertoast.showToast(msg: json.decode(response.body)["message"]);
      setState(() {
        showOtpTextBox = true;
        loading = false;
      });
      return VerifyMobile.fromJson(json.decode(response.body));
    } catch (e) {
      setState(() {
        showOtpTextBox = false;
        loading = false;
      });
      print(e);
    }
  }

  Future<Register> login() async {
    try {
      await getData();
      setState(() {
        loading = true;
      });
      var response = await http.post(
        api + "/api/v1/users/login",
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
      appBar: titleAppbar(context, title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            TextBoxEmailPhone(
              enabled: true,
              hintText: "Enter your Phone Number",
              labelText: "Phone",
              textEditingController: _phoneController,
              obscureText: false,
              textInputType: TextInputType.phone,
            ),
            !showOtpTextBox
                ? Container()
                : SizedBox(
                    height: 15,
                  ),
            !showOtpTextBox
                ? Container()
                : TextBoxEmailPhone(
                    enabled: true,
                    hintText: "Enter your otp",
                    labelText: "Name",
                    textEditingController: _otpController,
                    obscureText: false,
                    textInputType: TextInputType.phone,
                  ),
            SizedBox(
              height: 5,
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      bottom: 15.0,
                      left: 10,
                      right: 10,
                    ),
                    child: RaisedButton(
                      child: !showOtpTextBox
                          ? Text(
                              'Send Otp',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      onPressed: () async {
                        if (showOtpTextBox == false) {
                          if (_phoneController.text == "" ||
                              _phoneController.text.length < 10) {
                            Fluttertoast.showToast(
                                msg: "Please Enter a correct phone number");
                          } else {
                            await verifyPhone();
                          }
                        } else {
                          if (_otpController.text == "123456") {
                            await login();
                          } else {
                            Fluttertoast.showToast(
                              msg: "Your otp is incorrect!",
                            );
                          }
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
