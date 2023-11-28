import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/log.dart';

Future<List<Log>> fetchLogs(String category) async {
  // For now, let's assume we have a URL that returns logs based on category
  final response =
      await http.get(Uri.parse('https://example.com/logs?category=$category'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the logs
    List logs = json.decode(response.body);
    return logs
        .map((log) => Log(
            isError: log['isError'],
            content: log['content'],
            category: log['category']))
        .toList();
  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load logs');
  }
}
