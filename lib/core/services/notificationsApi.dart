import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final Payload? payload;

  ReceivedNotification copyWith({
    int? id,
    String? title,
    String? body,
    Payload? payload,
  }) {
    return ReceivedNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }

  factory ReceivedNotification.fromJson(Map<String, dynamic> json) {
    return ReceivedNotification(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "payload": payload?.toJson(),
      };

  @override
  String toString() {
    return '$id, $title, $body, $payload';
  }
}

class Payload {
  Payload();

  Payload copyWith() {
    return Payload();
  }

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload();
  }

  Map<String, dynamic> toJson() => {};

  @override
  String toString() {
    return '';
  }
}

/// A class that wraps the payload of a notification received when the app is in the foreground
/// or background.
/// See also:
/// * [NotificationsApi.didReceiveLocalNotificationSubject], which emits an instance of this class
///  when a notification is received when the app is in the foreground or background.
/// * [NotificationsApi.selectNotificationSubject], which emits an instance of this class
/// when a notification is tapped/clicked.
/// * [NotificationsApi.notificationAppLaunchDetails], which emits an instance of this class
/// when a notification that caused the application to launch is tapped/clicked.
/// * [NotificationsApi.showNotification], which shows a notification that will emit an instance of this class
/// when tapped/clicked.

class NotificationsApi {
  static final NotificationsApi _instance = NotificationsApi._internal();

  factory NotificationsApi() => _instance;

  NotificationsApi._internal();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  static final BehaviorSubject<ReceivedNotification> selectNotificationSubject = BehaviorSubject<ReceivedNotification>();
  static var notificationsStream = selectNotificationSubject.stream;

  static final Future<NotificationAppLaunchDetails?> notificationAppLaunchDetails = _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  static void listenForFirebaseNotifications() async {
    // For iOS request permission first.
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _firebaseMessaging.getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      
      selectNotificationSubject.add(ReceivedNotification(
        id: 0,
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: message.data.isNotEmpty ? Payload.fromJson(message.data) : null,
      ));
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
      }
    });
  }

  static void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
      id: id,
      title: title!,
      body: body!,
      payload: payload != null ? Payload.fromJson(jsonDecode(payload)) : null,
    ));
  }

  static void _onSelectNotification(NotificationResponse? response) async {
    // selectNotificationSubject.add(

    // );
  }

  static Future<void> init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings(
    //         onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onSelectNotification);
    tz.initializeTimeZones();

    listenForFirebaseNotifications();
  }

  static Future<void> showNotification({required String title, required String body, String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    // const MacOSNotificationDetails macOSPlatformChannelSpecifics =
    // MacOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static getToken() {
    return _firebaseMessaging.getToken();
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }

  // static Future<void> scheduleNotification({required String title, required String body, String? payload, required DateTime scheduledDate}) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'your channel id',
  //     'your channel name',
  //     channelDescription: 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  //   // const MacOSNotificationDetails macOSPlatformChannelSpecifics =
  //   // MacOSNotificationDetails();
  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );

  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     title,
  //     body,
  //     tz.TZDateTime.from(scheduledDate, tz.local),
  //     platformChannelSpecifics,
  //     payload: payload,
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  static Future<bool> callOnFcmApiSendPushNotifications({required String title, required String body, required String token}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      // send to token
      "to": "$token",
      // "to": "/topics/myTopic",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": 'Notify',
        "id": '1',
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      }
    };

    final headers = {
      'content-type': 'application/json',
      // q: how to get key from firebase?
      //ans: https://stackoverflow.com/questions/37418372/how-to-get-firebase-cloud-messaging-server-key 
      'Authorization':
          'key=AAAANWPDqvY:APA91bEj2zuAaDWEfokWL5k2miJIJQbtmr8LfdA7dje6iQDgJBefn18mQx7VHX6h2WOPLpeZKfaNu-ptmTkxXFny_oP9BBH_iHqeCRBbR2oiD_2WoLhluI4F2DZH6nAm6qREX4noHaKZ'
    };

    final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  static Future<bool> sendToTopicPushNotifications({required String title, required String body, required String topic
  , required String uid
  }) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      // send to topic
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": 'Notify',
        "topic": topic,
        "uid": uid,
        "id": '1',
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAOrttR98:APA91bHWlMbe8-HIqyyT4auChQ4H2S981TTQw3VWwLAScyfefO4Agw1VPCjj6F_oDsTSLr_WARu6JFOhLyPSFTqtFx6UEhpXeMjHRW78UCceKqzvmBdi9lgXMJbG0t32ZcVSFkBRM-3H'
    };

    final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
