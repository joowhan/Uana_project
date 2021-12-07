import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/*
레시피 provider
 */
class NotificationProvider extends ChangeNotifier {
  NotificationProvider() {
    init();
  }

  var notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Firebase.initializeApp();
    await configureLocalTimeZone();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true
    );
    final settings = InitializationSettings(android: android, iOS: iOS);
    await notifications.initialize(
      settings,
    );
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> expiredNotification(int foodCode, String foodName, String expiredDate) async {

    if(int.parse(expiredDate) <= 7) {
      expiredDate = "7";
    }

    await notifications.zonedSchedule(
        foodCode,
        '유통기한이 얼마 남지 않았습니다!',
        '$foodName의 유통기한이 일주일 이하로 남았습니다!',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 5, days: int.parse(expiredDate) - 7)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

    print("알람 생성 완료!");
  }

  Future<void> cancelNotification(int foodCode) async {
    await notifications.cancel(foodCode);
    print("알람 삭제 완료!");
  }
}