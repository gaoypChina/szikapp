import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/notification.dart';
import '../utils/utils.dart';

///Handler az app megnyitásakor jelenlevő üzenetek feldolgozására.
///Az FCM követelményei szerint top-level függvény lehet csak.
Future<void> _firebaseMessagingInitialHandler(RemoteMessage message) async {
  if (message.notification != null) {
    NotificationManager.instance.addMessage(message);
  }
}

///Handler a háttérben lévő appnak érkező üzenetek feldolgozására.
///Az FCM követelményei szerint top-level függvény lehet csak.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /*await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (message.notification != null) {
    NotificationManager.instance.addMessage(message);
  }*/
}

///Értesítéseket kezelő singleton osztály. Szerver és kliens közti rétegként
///a Firebase Cloud Messaging szolgáltatását használja.
class NotificationManager extends ChangeNotifier {
  final messaging = FirebaseMessaging.instance;

  final List<CustomNotification> _notifications = [];

  /// Singleton osztálypéldány
  static final NotificationManager _instance =
      NotificationManager._privateConstructor();

  /// Publikus konstruktor, ami visszaadja az egyetlen [NotificationManager] példányt
  factory NotificationManager() => _instance;
  static NotificationManager get instance => _instance;

  /// Privát konstruktor
  NotificationManager._privateConstructor();

  List<CustomNotification> get notifications => _notifications;

  void addMessage(RemoteMessage message) {
    var rawTopic = message.data['topic'];
    var topic = NotificationTopic.values
        .firstWhere((topic) => topic.toString() == rawTopic);
    var notificationPath = notificationPaths[topic];
    if (message.notification != null) {
      _notifications.add(CustomNotification(
        title: message.notification!.title ?? '',
        body: message.notification!.body,
        route: notificationPath?.path,
        iconPath: notificationPath?.iconPath ?? CustomIcons.bell,
      ));
    }
    notifyListeners();
  }

  void dismissMessage(CustomNotification message) {
    _notifications.remove(message);
    notifyListeners();
  }

  //Call on the Feed Screen
  void dismissAllMessages() {
    _notifications.removeRange(0, _notifications.length);
    notifyListeners();
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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      // Feliratkozás minden kötelező notification topicra
      subscribeToTopics(obligatoryTopics);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          addMessage(message);
        }
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    }
  }

  Future<void> saveTokenToDatabase(String? token) async {
    var fcmToken = token ?? await messaging.getToken();
    if (fcmToken == null) return;
    var io = IO();
    io.saveFCMToken(parameters: {'token': fcmToken});
  }

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
      messaging.subscribeToTopic(topic.toString());
    }
  }

  Future<void> unsubscribeFromTopic(NotificationTopic topic) async {
    await messaging.unsubscribeFromTopic(topic.toString());
  }

  Future<void> unsubscribeFromTopics(List<NotificationTopic> topics) async {
    for (var topic in topics) {
      messaging.unsubscribeFromTopic(topic.toString());
    }
  }
}
