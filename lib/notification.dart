import 'dart:io';
import 'dart:typed_data';
import 'package:deltastore/main_order.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:device_info/device_info.dart';
import 'main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging firebaseMessaging = FirebaseMessaging();

showNotification({title, body}) async {
  final Int64List vibrationPattern = new Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 500;
  vibrationPattern[3] = 2000;

  var android = new AndroidNotificationDetails(
    'channel id',
    'channel NAME',
    'CHANNEL DESCRIPTION',
    icon: 'logo_new',
    priority: Priority.high,
    importance: Importance.max,
    vibrationPattern: vibrationPattern,
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: iOS);
  await flutterLocalNotificationsPlugin.show(0, title, body, platform,
      payload: 'AndroidCoding.in');
}

// class MyNotification extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

void initFirebaseMessaging() {
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      Map mapNotification = message["notification"];
      String title = mapNotification["title"];
      String body = mapNotification["body"];
      showNotification(title: title, body: body);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );

  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
}

Future initPlatformState() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  String tokenData;

  try {
   await firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      tokenData = token;
      print("Token : $token");
    });
    if (Platform.isAndroid) {
      deviceData =
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo, tokenData);
    } else if (Platform.isIOS) {
      deviceData =
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo, tokenData);
    }
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }
  print(deviceData);
  return deviceData;
}

Map<String, dynamic> _readAndroidBuildData(
    AndroidDeviceInfo build, String tokenData) {
  return <String, dynamic>{
    'platform': 'Android',
    'token': tokenData,
    'uuid': build.androidId,
    'version': build.version.release,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data, String tokenData) {
  return <String, dynamic>{
    'platform': 'Ios',
    'token': tokenData,
    'uuid': data.identifierForVendor,
    'version:': data.utsname.release,

  };
}

void loadInfo()async{
  deviceData = await initPlatformState();
}

Future orderNoti()async{
  bool first = true;

  notification.onValue.listen((event) {
    if(!first){
      showNotification(title: 'อัพเดตออร์เดอร์',body: 'ตรวจสอบออร์เดอร์ใหม่');
    }else{
      first = false;
    }
  });

}
