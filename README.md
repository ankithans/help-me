# Help-me

<!-- <img src="https://github.com/ankithans/help-me/blob/main/mockups/WhatsApp%20Image%202020-11-08%20at%202.04.12%20PM.jpeg" width="700"> -->

## 🔗 Links
- [Help-me apk](https://github.com/ankithans/help-me/releases/download/v1.0/app-armeabi-v7a-release.apk)
- [Backend API](https://help-mee.herokuapp.com/)
- [API documentation](https://documenter.getpostman.com/view/11391372/TVYQ2EBd#136607c4-b3cb-4e7f-9c96-82f7950aeee7)
- [Video Explanation](https://vimeo.com/476800666)

## ❓ Problem Statement
> Security is a major concern today. As sad this might sound, India or any part of the world for that matter cannot be called completely safe. And as such any cry for help should always get the proper response that the person needs. Thus, we bring forward helpMe. helpMe is our contribution towards a safer world where no one is alone and a step towards a much safer world.
Whenever in distress, press a button and this will automatically notify people nearby of your location and others can respond to your distress call. This creates a social responsibility among users and eliminates any central body ensuring quicker response to any distress calls.

## 🤔 Challenges we faced
- Handling location changes in the background
- Finding nearby users (queries in mongodb using geolocation object)
- Configuring Hardware buttons (comming soon) 

## 💡 features
- send distress messages automatically when you are in trouble
- receive notifications from others when they are in trouble and access their location using google maps
- add close contacts (automatically send them messages when you are in trouble)
- configure hardware buttons (comming soon)

## 💻 samples:

<img src="https://github.com/ankithans/help-me/blob/main/mockups/1.jpeg" width="250"> &nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/ankithans/help-me/blob/main/mockups/2.jpeg" width="250" style="float:right"> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/ankithans/help-me/blob/main/mockups/3.jpeg" width="250">

<img src="https://github.com/ankithans/help-me/blob/main/mockups/3.1.jpeg" width="250"> &nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/ankithans/help-me/blob/main/mockups/4.jpeg" width="250" style="float:right"> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/ankithans/help-me/blob/main/mockups/5.jpeg" width="250">

<img src="https://github.com/ankithans/help-me/blob/main/mockups/6.jpeg" width="250"> &nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/ankithans/help-me/blob/main/mockups/7.jpeg" width="250" style="float:right"> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <img src="https://github.com/ankithans/help-me/blob/main/mockups/8.jpeg" width="250">

## 👣 steps to run the project
- clone the repo in your local machine
- do ```yarn``` in root directory
- do ```flutter pub get``` in ```client/helpMe```
- add firebase to your flutter project and firebaseadminsdk.json in your root directory
- add MONGO_URI, JWT_SECRET, TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN in your .env
- do ```yarn dev``` in the root directory and your backend is up and running
- do ```flutter run``` in ```client/helpMe``` and your app will start with no issues

## Tech Stacks & dependencies
##### 🤖 Backend
- nodejs
- mongodb
- Heroku
- Firebase FCM
- twilio

##### 🌟 Frontend
- Flutter for cross-platform application
- [location](https://pub.dev/packages/location)    
- [http](https://pub.dev/packages/http)
- [firebase_messaging](https://pub.dev/packages/firebase_messaging)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [workmanager](https://pub.dev/packages/workmanager)
- [maps_launcher](https://pub.dev/packages/maps_launcher)

## made with 💕 by: 
- [Ankit Hans](https://github.com/ankithans)
- [Sagnik Biswas](https://github.com/sbiswas2209)
- [Harshit Singh](https://github.com/HarshitSingh27)
