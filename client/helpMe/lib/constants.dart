import 'package:flutter/material.dart';

const api = 'https://help-mee.herokuapp.com';

const backgroundColor = Color(0XFF212121);

const primaryColor = Color(0XFF32e0c4);

const fontColor = Color(0XFFeeeeee);

AppBar titleAppbar(context,
    {@required String title,
    List<Widget> actions,
    bool automaticallyImplyLeading = true,
    bool centerTitle = false,
    Widget leading}) {
  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: centerTitle,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions != null ? actions : null,
    title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "$title",
        overflow: TextOverflow.fade,
        style: Theme.of(context).textTheme.headline1,
      ),
    ),
  );
}
