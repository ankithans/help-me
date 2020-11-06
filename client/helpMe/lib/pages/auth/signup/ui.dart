import 'package:flutter/material.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/auth/login/ui.dart';
import 'package:helpMe/pages/auth/signup/services.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _phone = null;
  String _name = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 2.0, color: primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 2.0, color: primaryColor),
                  ),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: primaryColor
                  ),
                ),
                style: TextStyle(
                  color: fontColor
                ),
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 2.0, color: primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 2.0, color: primaryColor),
                  ),
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: primaryColor
                  ),
                ),
                style: TextStyle(
                  color: fontColor
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: RaisedButton(
                child: Text('Sign Up'),
                onPressed: (){
                  if(_phone != null && _name != null){
                    String phone = _phone.trim();
                    print(phone);
                    SignUpService().registerUser(context, phone: phone);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: primaryColor,
              ),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
              }, 
              child: Text('Log In', style: Theme.of(context).textTheme.bodyText1.copyWith(color: primaryColor),)
            ),
          ],
        ),
      ),
    );
  }
}