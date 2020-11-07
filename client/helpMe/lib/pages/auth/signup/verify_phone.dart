import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/models/verify_phone.dart';
import 'package:helpMe/pages/auth/login/login.dart';
import 'package:helpMe/pages/auth/signup/signup.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/text_box.dart';

//import 'package:helpMe/pages/auth/signup/services.dart';
class VerifyPhone extends StatefulWidget {
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final _phoneController = new TextEditingController();
  final _otpController = new TextEditingController();
  bool showOtpTextBox = false;
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool loading = false;

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
      if (json.decode(response.body)["success"] == false) {
        setState(() {
          showOtpTextBox = false;
          loading = false;
        });
        Fluttertoast.showToast(msg: json.decode(response.body)["error"]);
      } else {
        Fluttertoast.showToast(msg: json.decode(response.body)["message"]);
        setState(() {
          showOtpTextBox = true;
          loading = false;
        });
      }
      return VerifyMobile.fromJson(json.decode(response.body));
    } catch (e) {
      setState(() {
        showOtpTextBox = false;
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
            Padding(
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
                        'Sign Up',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(
                            phone: _phoneController.text,
                          ),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(msg: "Your otp is incorrect!");
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: primaryColor,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: primaryColor),
                    )),
          ],
        ),
      ),
    );
  }
}
