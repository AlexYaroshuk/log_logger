import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/script.dart';
import '../config.dart';

Future<List<Script>> fetchScripts() async {
  try {
    print('Fetching logs...');
    final response = await http.get(Uri.parse('${Config.API_URL}/scripts'));

    if (response.statusCode == 200) {
      print('Response received. Parsing scripts...');
      List scripts = json.decode(response.body);
      print(scripts);

      return scripts.map((script) => Script.fromJson(script)).toList();
    } else {
      print('Server returned status code: ${response.statusCode}');
      throw Exception('Failed to load scripts');
    }
  } catch (e) {
    print('An error occurred: $e');
    throw e;
  }
}
