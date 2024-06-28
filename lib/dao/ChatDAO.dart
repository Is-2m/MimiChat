import 'dart:convert';

import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class ChatDao {
  static final String _apiUrl = "${AppStateManager.apiURL}/chats";

  static Future<List<Chat>> getChats({required String userId}) async {
    var localApi = "$_apiUrl/$userId/all";
    List<Chat> chats = [];
    try {
      final response = await http.get(
        Uri.parse(localApi),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AppStateManager.getToken()}"
        },
      );
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

  static Future<Chat?> createChat(Chat chat) async {
    String localApi = "$_apiUrl/create";

    try {
      var response = await http.post(
        Uri.parse(localApi),
        body: jsonEncode(chat.toJson()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AppStateManager.getToken()}"
        },
      );
      if (response.statusCode == 200) {
        return Chat.fromJson(jsonDecode(response.body));
      } else {
        print("[ChatDAO.createChat().else] - Failed to create chat");
        return null;
      }
    } catch (e) {
      print("[ChatDAO.createChat().catch] - $e");
      return null;
    }
  }
}
