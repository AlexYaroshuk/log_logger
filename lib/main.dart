import 'package:flutter/material.dart';
import './app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './services/notification_manager.dart';

final NotificationManager _notificationManager = NotificationManager();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  _notificationManager.initialize();
  runApp(App());
}
