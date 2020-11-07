import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/auth/login/ui.dart';
import 'package:helpMe/pages/home/ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  void fcmListener() {
    _firebaseMessaging.getToken().then((value) async {
      await secureStorage.write(key: 'fcmToken', value: value);
      print(value);
    });

    Widget _buildDialog(BuildContext context) {
      return AlertDialog(
        content: Text("Item  has been updated"),
        actions: <Widget>[
          FlatButton(
            child: const Text('CLOSE'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: const Text('SHOW'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    }

    void _showItemDialog(Map<String, dynamic> message) {
      showDialog(
        context: context,
        builder: (_) => _buildDialog(context),
      );
    }

    Future<void> showNotification(String title, String body) async {
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID',
        'CHANNEL_NAME',
        "CHANNEL_DESCRIPTION",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      );
      var iosChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidChannelSpecifics, iOS: iosChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title, // Notification Title
        body, // Notification Body, set as null to remove the body
        platformChannelSpecifics,
        payload: 'New Payload', // Notification Payload
      );
    }

    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('onMessage: $message');
        Fluttertoast.showToast(msg: "$message");

        showNotification(
            message["notification"]["title"], message["notification"]["body"]);
        _showItemDialog(message);
      },
      onLaunch: (message) async {
        print('onLaunch: $message');
      },
      onResume: (message) async {
        print('onResume: $message');
      },
    );
  }

  @override
  void initState() {
    super.initState();

    fcmListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'Nunito',
            color: primaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1:
              TextStyle(fontFamily: 'Nunito', color: fontColor, fontSize: 15.0),
        ),
      ),
      home: HomePage(),
    );
  }
}
