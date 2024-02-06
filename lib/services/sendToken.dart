import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../config.dart';

void sendToken(String token, String label) async {

  String  url = 'https://api.airtable.com/v0/${Config.AIRTABLE_BASE_ID}/${Config.AIRTABLE_TABLE_ID}';
    Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${Config.AIRTABLE_API_KEY}',
  };

  Map<String, dynamic> data = {
    'fields': {
      'Label': label,
      'Token': token,
      // Add more fields as needed
    },
  };

  try {
     http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(data),
  );

    if (response.statusCode == 200 || response.statusCode == 201){
      Fluttertoast.showToast(
        msg: "Post request successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
      print('Post request successful');
      print('Response: ${response.body}');
    } else {
      Fluttertoast.showToast(
        msg: "Post request failed with status: ${response.statusCode}, body: ${response.body}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      print('Post request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "Error making POST request: $error",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
    print('Error making POST request: $error');
  }
}