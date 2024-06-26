import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mimichat/models/CallHistory.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';
import 'package:mimichat/providers/CallProvider.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:provider/provider.dart';

class WebSocketsHandler {
  static void wsHandler(BuildContext ctx, String body) {
    Map<String, dynamic> bodyJson = json.decode(body);
    switch (bodyJson["type"]) {
      case "message":
        _handleMsg(ctx, bodyJson);
        break;
      case "chat":
        _handleChat(ctx, bodyJson);
        break;
      case "call":
        _handleIncomingCall(ctx, bodyJson);
        break;
      default:
        print("[WebSocketsHandler.wsHandler] Defaulted");
    }
  }

  static void _handleIncomingCall(
      BuildContext ctx, Map<String, dynamic> bodyJson) {
    CallHistory call = CallHistory.fromJson(bodyJson["data"]);
    Provider.of<CallProvider>(ctx, listen: false).addIncomingCall(call);
  }

  static void _handleMsg(BuildContext ctx, Map<String, dynamic> bodyJson) {
    Message msg = Message.fromJson(bodyJson["data"]);
    String chatId = bodyJson["add_info"];
    Provider.of<ChatsProvider>(ctx, listen: false).addMessage(chatId, msg);
  }

  static void _handleChat(BuildContext ctx, Map<String, dynamic> bodyJson) {
    Chat chat = Chat.fromJson(bodyJson["data"]);
    Provider.of<ChatsProvider>(ctx, listen: false).addChat(chat);
  }
}
