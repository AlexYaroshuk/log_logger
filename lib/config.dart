import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get API_URL => dotenv.env['API_URL'] ?? 'default_url';
  static String get FCM_URL => dotenv.env['FCM_URL'] ?? 'default_url';
  static String get AIRTABLE_API_KEY => dotenv.env['AIRTABLE_API_KEY'] ?? 'default_url';
  static String get AIRTABLE_BASE_ID => dotenv.env['AIRTABLE_BASE_ID'] ?? 'default_url';
  static String get AIRTABLE_TABLE_ID => dotenv.env['AIRTABLE_TABLE_ID'] ?? 'default_url';
}
