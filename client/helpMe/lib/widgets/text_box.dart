import 'package:flutter/material.dart';

class TextBoxEmailPhone extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final Function onChanged;
  final bool obscureText;
  final bool enabled;

  const TextBoxEmailPhone(
      {Key key,
      this.hintText,
      this.labelText,
      this.textEditingController,
      this.textInputType,
      this.onChanged,
      this.obscureText,
      this.enabled})
      : super(key: key);

  @override
  _TextBoxEmailPhoneState createState() => _TextBoxEmailPhoneState();
}

class _TextBoxEmailPhoneState extends State<TextBoxEmailPhone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: widget.textEditingController,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText,
        enabled: widget.enabled == null ? true : widget.enabled,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          ),
          focusColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.only(left: 15.0, bottom: 8.0, top: 10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.black)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.yellowAccent)),
        ),
      ),
    );
  }
}
