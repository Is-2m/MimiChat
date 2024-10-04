import 'package:http/http.dart' as http;

class BaseService {
  static void runBackend() {
    String backendUrl = "https://mimichat-backend.onrender.com";
    http.get(Uri.parse(backendUrl));
  }
}
