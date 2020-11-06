import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpMe/pages/home/ui.dart';

class SignUpService{

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerUser(context, {@required String phone}){

    _auth.verifyPhoneNumber(
      phoneNumber: phone, 
      timeout: Duration(minutes: 2),
      verificationCompleted: (AuthCredential credential){
        _auth.signInWithCredential(credential).then((value){
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
        }).catchError((err) {
          print(err);
        });
      }, 
      verificationFailed: (FirebaseAuthException exception) {
        print(exception.message);
      }, 
      codeSent: (String verificationId, [int forceResendingToken]){
        TextEditingController _codeController;
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter SMS Code'),
              content: Column(
                children: [
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    String code = _codeController.text.trim();
                    var _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
                    _auth.signInWithCredential(_credential).then((value){
                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
                    }).catchError((err) {
                       print(err);
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }, 
      codeAutoRetrievalTimeout: (String verificationId){
        verificationId = verificationId;
        print(verificationId);
        print('Timeout');
      }
    );

  }

}