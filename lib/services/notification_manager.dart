import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() async {
       String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}