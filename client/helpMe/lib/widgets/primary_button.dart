import 'package:flutter/material.dart';

import '../constants.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final Widget titleWidget;

  PrimaryButton({
    this.title,
    this.onPressed,
    this.titleWidget,
  });
  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        elevation: 0,
        onPressed: widget.onPressed,
        color: backgroundColor,
        shape: Border.all(
          color: primaryColor,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
