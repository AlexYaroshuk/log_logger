import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/session.dart';
import '../config.dart';

Future<List<Session>> fetchSessions(int scriptId) async {
  try {
    print('Fetching sessions...');
    final response =
        await http.get(Uri.parse('${Config.API_URL}/session/${scriptId}'));

    if (response.statusCode == 200) {
      print('Response received. Parsing sessions...');
      List sessions = json.decode(response.body);
      print(sessions);

      return sessions.map((session) => Session.fromJson(session)).toList();
    } else {
      print('Server returned status code: ${response.statusCode}');
      throw Exception('Failed to load sessions');
    }
  } catch (e) {
    print('An error occurred while fetching sessions: $e');
    throw e;
  }
}
