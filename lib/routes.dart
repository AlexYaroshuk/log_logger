import 'package:flutter/material.dart';
import 'pages/programs.dart';
import '../pages/sessions.dart';
import 'pages/logs.dart';
import 'pages/loginfo.dart';
import 'models/log.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => ProgramsPage(),
  '/logs': (context) =>
      LogsPage(sessionId: ModalRoute.of(context)!.settings.arguments as int),
  '/sessions': (context) => SessionsPage(
        programId: (ModalRoute.of(context)!.settings.arguments as int),
      ),
  '/log': (context) =>
      LogPage(log: ModalRoute.of(context)!.settings.arguments as Log),
};
