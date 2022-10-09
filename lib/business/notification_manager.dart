import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../utils/utils.dart';

///Handler az app megnyitásakor jelenlevő üzenetek feldolgozására.
///Az FCM követelményei szerint top-level függvény lehet csak.
Future<void> _firebaseMessagingInitialHandler(RemoteMessage message) async {
  //TODO Navigate to the right location
  if (message.notification != null) {
    NotificationManager.instance.addMessage(message);
  }
}

///Handler a háttérben lévő appnak érkező üzenetek feldolgozására.
///Az FCM követelményei szerint top-level függvény lehet csak.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    NotificationManager.instance.addMessage(message);
  }
}

///Értesítéseket kezelő singleton osztály. Szerver és kliens közti rétegként
///a Firebase Cloud Messaging szolgáltatását használja.
class NotificationManager extends ChangeNotifier {
  final messaging = FirebaseMessaging.instance;

  final List<RemoteMessage> _messages = [];

  /// Singleton osztálypéldány
  static final NotificationManager _instance =
      NotificationManager._privateConstructor();

  /// Publikus konstruktor, ami visszaadja az egyetlen [NotificationManager] példányt
  factory NotificationManager() => _instance;
  static NotificationManager get instance => _instance;

  /// Privát konstruktor
  NotificationManager._privateConstructor();

  List<RemoteMessage> get messages => _messages;

  List<CustomNotification> get notifications => _buildCustomNotifications();

  List<CustomNotification> _buildCustomNotifications() {
    var result = <CustomNotification>[];
    for (var item in _messages) {
      if (item.notification != null) {
        result.add(CustomNotification(
          title: item.notification!.title ?? '',
          body: item.notification!.body,
        ));
      }
    }
    return result;
  }

  void addMessage(RemoteMessage message) {
    _messages.add(message);
  }

  void dismissMessage(CustomNotification message) {
    _messages.remove(_messages
        .firstWhere((element) => element.notification?.title == message.title));
  }

  //Call on the Feed Screen
  void dismissAllMessages() {
    _messages.removeRange(0, _messages.length);
  }

  Future<void> initialize() async {
    var settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    //TODO Check what happens when permissions are not given
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //TODO Check if it works
        if (message.notification != null) {
          _messages.add(message);
        }
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    }
  }

  Future<void> saveTokenToDatabase(String? token) async {
    token ??= await messaging.getToken();
    var io = IO();
    io.saveFCMToken(token!);
  }

  //Todo check if it works
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _firebaseMessagingInitialHandler(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingInitialHandler);
  }

  Future<void> subscribeToTopic(NotificationTopic topic) async {
    await messaging.subscribeToTopic(topic.toString());
  }

  Future<void> subscribeToTopics(List<NotificationTopic> topics) async {
    for (var topic in topics) {
      await messaging.subscribeToTopic(topic.toString());
    }
  }

  Future<void> unsubscribeFromTopic(NotificationTopic topic) async {
    await messaging.unsubscribeFromTopic(topic.toString());
  }

  Future<void> unsubscribeFromTopics(List<NotificationTopic> topics) async {
    for (var topic in topics) {
      await messaging.unsubscribeFromTopic(topic.toString());
    }
  }
}
