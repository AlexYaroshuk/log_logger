import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/script.dart';
import '../config.dart';

Future<List<Script>> fetchScripts() async {
  final client = HttpClient();
  client.connectionTimeout = Duration(seconds: 3); // Set connection timeout

  try {
    print('Fetching logs...');
    final request = await client.getUrl(Uri.parse('${Config.API_URL}/scripts'));
    final response = await request.close();

    if (response.statusCode == 200) {
      print('Response received. Parsing scripts...');
      final responseBody = await response.transform(utf8.decoder).join();
      List scripts = json.decode(responseBody);
      print(scripts);

      return scripts.map((script) => Script.fromJson(script)).toList();
    } else {
      print('Server returned status code: ${response.statusCode}');
      throw 'Failed to load scripts';
    }
  } on SocketException catch (e) {
    print('SocketException: $e');
    throw 'Could not establish a connection to the server. Please check your network connection.';
  } catch (e) {
    print('An error occurred: $e');
    throw e.toString();
  }
}
