import 'package:flutter/material.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/auth/signup/ui.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: titleAppbar(context, title: 'Login'),
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
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: TextField(
            //     keyboardType: TextInputType.name,
            //     decoration: InputDecoration(
            //       disabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: BorderSide(width: 2.0, color: primaryColor),
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: BorderSide(width: 2.0, color: primaryColor),
            //       ),
            //       labelText: 'Name',
            //       labelStyle: TextStyle(
            //         color: primaryColor
            //       ),
            //     ),
            //     style: TextStyle(
            //       color: fontColor
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: RaisedButton(
                child: Text('Login'),
                onPressed: (){},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: primaryColor,
              ),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => SignUpPage()));
              }, 
              child: Text('Sign Up', style: Theme.of(context).textTheme.bodyText1.copyWith(color: primaryColor),)
            ),
          ],
        ),
      ),
    );
  }
}