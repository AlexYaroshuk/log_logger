import 'package:flutter/material.dart';
import 'routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Log Viewer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.teal, // This changes the primary color
              secondary: Colors.teal,
            ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.teal,
          selectionColor: Colors.teal,
          selectionHandleColor: Colors.teal,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.teal,
        ),
        tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.teal, width: 2.0),
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
