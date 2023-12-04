import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get API_URL => dotenv.env['API_URL'] ?? 'default_url';
}
