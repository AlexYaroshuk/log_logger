import 'package:flutter/material.dart';
import 'pages/scripts.dart';
import '../pages/sessions.dart';
import 'pages/logs.dart';
import 'pages/loginfo.dart';
import 'models/log.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => ScriptsPage(),
  '/logs': (context) =>
      LogsPage(sessionId: ModalRoute.of(context)!.settings.arguments as int),
  '/sessions': (context) => SessionsPage(
        scriptId: (ModalRoute.of(context)!.settings.arguments as int),
      ),
  '/log': (context) =>
      LogPage(log: ModalRoute.of(context)!.settings.arguments as Log),
};
