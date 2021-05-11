import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  Function onMessage;
  Function onLaunch;
  Function onResume;
  Function getTokenCallback;

  FirebaseNotifications.handler(
      this.onMessage, this.onLaunch, this.onResume, this.getTokenCallback) {
    _firebaseMessaging = FirebaseMessaging();
  }
  FirebaseNotifications.getToken(this.getTokenCallback) {
    _firebaseMessaging = FirebaseMessaging();

    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      getTokenCallback(token);
    });
  }

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      getTokenCallback(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        onMessage(message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        onResume();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        onLaunch();
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
