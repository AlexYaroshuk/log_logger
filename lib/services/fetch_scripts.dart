import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/script.dart';
import '../config.dart';

Future<List<Script>> fetchScripts({bool withTimeout = true}) async {
  try {
    print('Fetching logs...');
    final responseFuture = http.get(Uri.parse('${Config.API_URL}/scripts'));

    http.Response response;
    if (withTimeout) {
      response = await responseFuture.timeout(Duration(seconds: 3));
    } else {
      response = await responseFuture;
    }

    if (response.statusCode == 200) {
      print('Response received. Parsing scripts...');
      List scripts = json.decode(response.body);
      print(scripts);

      return scripts.map((script) => Script.fromJson(script)).toList();
    } else {
      print('Server returned status code: ${response.statusCode}');
      throw 'Failed to load scripts';
    }
  } on SocketException catch (e) {
    print('SocketException: $e');
    throw 'No internet connection.\n Check your network settings. error: $e';
  } on TimeoutException catch (e) {
    print('TimeoutException: $e');
    throw 'Request timed out.\n Ensure that you have access rights.';
  } catch (e) {
    print('An error occurred: $e');
    throw e.toString();
  }
}
