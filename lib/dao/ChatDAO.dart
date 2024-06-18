import 'dart:convert';

import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class ChatDao {
  static final String _apiUrl = "${AppStateManager.apiURL}/chat";

  static Future<List<Chat>> getChats({required String userId}) async {
    var localApi = "$_apiUrl/$userId/all";
    List<Chat> chats = [];
    print("Url : $localApi");
    try {
      final response = await http.get(Uri.parse(localApi));
      if (response.statusCode == 200) {
        for (var chat in jsonDecode(response.body) as List) {
          chats.add(Chat.fromJson(chat));
        }
        return chats;
      } else {
        throw Exception("[ChatDAO.getChats().else] - Failed to load chats");
      }
    } catch (e) {
      print(e);
    }
    return chats;
  }
}
