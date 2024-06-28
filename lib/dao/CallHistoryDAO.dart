import 'package:mimichat/models/CallHistory.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class CallHistoryDAO {
  static String _apiUrl = AppStateManager.apiURL + "/call";

  static Future<void> updateCall(CallHistory call) async {
    var url = '$_apiUrl/${call.id}';
    Uri uri = Uri.parse(url);
    try {
      final response = await http.put(uri, body: call.toJson(), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppStateManager.getToken()}"
      });
      if (response.statusCode == 200) {
        print("[CallHistoryDAO.updateCall]: Call updated successfully");
      } else {
        print("[CallHistoryDAO.updateCall]:  Failed to update call ");
      }
    } catch (r) {
      print("[CallHistoryDAO.updateCall]:  Failed to update call");
    }
  }
}
