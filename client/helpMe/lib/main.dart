import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpMe/constants.dart';
import 'package:helpMe/pages/auth/login/login.dart';
import 'package:helpMe/pages/auth/signup/signup.dart';
import 'package:helpMe/pages/auth/signup/verify_phone.dart';
import 'package:helpMe/pages/home/ui.dart';
import 'package:location/location.dart';

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
  String token;

  void fcmListener() {
    _firebaseMessaging.getToken().then((value) async {
      await secureStorage.write(key: 'fcmToken', value: value);
      print(value);
    });

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
        1, // Notification ID
        title, // Notification Title
        body, // Notification Body, set as null to remove the body
        platformChannelSpecifics,
      );
    }

    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('onMessage: $message');
        Fluttertoast.showToast(msg: "$message");

        showNotification(
            message["notification"]["title"], message["notification"]["body"]);
      },
      onLaunch: (message) async {
        print('onLaunch: $message');
      },
      onResume: (message) async {
        print('onResume: $message');
      },
    );
  }

  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    print(_locationData);
    await secureStorage.write(
        key: 'longitude', value: _locationData.longitude.toString());
    await secureStorage.write(
        key: 'latitude', value: _locationData.latitude.toString());
  }

  void getToken() async {
    token = await secureStorage.read(key: "token");
    print(token);
  }

  Widget firstScreen() {
    if (token == null) {
      return VerifyPhone();
    } else {
      return HomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    getLocation();
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
      home: firstScreen(),
    );
  }
}
