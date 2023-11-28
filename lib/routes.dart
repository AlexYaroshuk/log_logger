import 'package:flutter/material.dart';
import '../pages/home.dart';
import '../pages/list.dart';
import '../pages/log.dart';
import 'models/log.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => HomePage(),
  '/list': (context) =>
      ListPage(category: ModalRoute.of(context)!.settings.arguments as String),
  '/log': (context) =>
      LogPage(log: ModalRoute.of(context)!.settings.arguments as Log),
};
