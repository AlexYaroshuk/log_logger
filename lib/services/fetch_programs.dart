import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/program.dart';
import '../config.dart';

Future<List<Program>> fetchPrograms({bool withTimeout = true}) async {
  try {
    print('Fetching programs...');
    final responseFuture = http.get(Uri.parse('${Config.API_URL}/program/1'));

    http.Response response;
    if (withTimeout) {
      response = await responseFuture.timeout(Duration(seconds: 3));
    } else {
      response = await responseFuture;
    }

    if (response.statusCode == 200) {
      print('Response received. Parsing programs...');
      List programs = json.decode(response.body);
      print(programs);

      return programs.map((program) => Program.fromJson(program)).toList();
    } else {
      print('Server returned status code: ${response.statusCode}');
      throw 'Failed to load programs';
    }
  } on SocketException catch (e) {
    print('SocketException: $e');
    throw 'No internet connection.\n Check your network settings.';
  } on TimeoutException catch (e) {
    print('TimeoutException: $e');
    throw 'Request timed out.\n Ensure that you have access rights.';
  } catch (e) {
    print('An error occurred: $e');
    throw e.toString();
  }
}
