import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('onMessage: $message');
        _showItemDialog(message);
        _showNotification(
            1234,
            "GET title FROM message OBJECT",
            "GET description FROM message OBJECT",
            "GET PAYLOAD FROM message OBJECT");
      },
      onLaunch: (message) async {
        print('onLaunch: $message');
      },
      onResume: (message) async {
        print('onResume: $message');
      },
    );
  }

  Future<dynamic> onSelectNotification(String payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(payload),
        content: Text("Payload: $payload"),
      ),
    );
  }

  Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1234',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
                  fontWeight: FontWeight.bold),
              bodyText1: TextStyle(
                  fontFamily: 'Nunito', color: fontColor, fontSize: 15.0))),
      home: LoginPage(),
    );
  }
}
