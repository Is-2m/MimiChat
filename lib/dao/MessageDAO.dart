import 'dart:convert';
import 'dart:developer';

import 'package:mimichat/models/Message.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class MessageDAO {
  static final String _apiURL = "${AppStateManager.apiURL}/message-log";

  static Future<Message?> saveMessage(String chatID, Message msg) async {
    Map<String, dynamic> body = {
      "chat": {"id": chatID},
      "sender": msg.sender,
      "receiver": msg.receiver,
      "content": msg.content,
      "date": "${msg.date.toUtc().millisecondsSinceEpoch}",
    };
    Message? msgReply;
    try {
      var response = await http.post(
        Uri.parse(_apiURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      if (response.statusCode != 200) {
        inspect(response.body);
        print(
            "[MessageDAO.saveMessage.if] Failed to save message\n${response.body}");
        return msgReply;
      } else {
        msgReply = Message.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("[MessageDAO.saveMessage.catch]:\n $e");
      return msgReply;
    }
  }
}
