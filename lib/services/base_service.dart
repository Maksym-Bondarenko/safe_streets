import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Here goes all information regarding connection with the backend
/// e.g. port, API-keys, http, etc.
class BaseService {
  final String host = "34.159.7.34";
  // Uncomment following line for testing with local server
  //host = "localhost";

  final String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
}