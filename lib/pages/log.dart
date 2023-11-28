import 'package:flutter/material.dart';
import '../models/log.dart';

class LogPage extends StatelessWidget {
  final Log log;

  LogPage({required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Is Error: ${log.isError ? 'Yes' : 'No'}'),
            SizedBox(height: 8.0),
            Text('Content: ${log.content}'),
            SizedBox(height: 8.0),
            Text('Category: ${log.category}'),
          ],
        ),
      ),
    );
  }
}
