import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/log.dart';
import '../config.dart';

Future<List<Log>> fetchLogs(int sessionId,
    {int offset = 0, int limit = 100}) async {
  try {
    print('Fetching logs...');
    final response = await http.get(Uri.parse(
        '${Config.API_URL}/log/${sessionId}?offset=$offset&limit=$limit'));
    // rest of your code
    if (response.statusCode == 200) {
      print('Response received. Parsing logs...');
      List logs = json.decode(response.body);
      print(logs);

      return logs.map((log) => Log.fromJson(log)).toList();
    } else {
      print('Server returned status code: ${response.statusCode}');
      throw Exception('Failed to load logs');
    }
  } catch (e) {
    print('An error occurred while fetching logs: $e');
    throw e;
  }
}
