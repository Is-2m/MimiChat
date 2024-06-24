import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mimichat/main.dart';
import 'package:mimichat/models/Message.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:mimichat/sockets/WsStompConfig.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:provider/provider.dart';

// final StreamController<Message> messageStreamController = StreamController<Message>.broadcast();

class WsStompMessage {
  static final String subscrib_path = "/topic/chats";
  static final String send_path = "/app/chats";

  static void subscribe({
    required String chatId,
    required Function(String chatId, Message message) onMessageReceived,
  }) {
    try {
      if (WsStompConfig.stompClient.connected) {
        var path = "$subscrib_path/$chatId/msg";
        WsStompConfig.stompClient.subscribe(
          destination: path,
          callback: (frame) {
            if (frame.body != null) {
              final chatId = frame.headers['destination']?.split('/')[3];
              if (chatId != null) {
                final message = Message.fromJson(jsonDecode(frame.body!));
                onMessageReceived(chatId, message);
              }
            }
          },
        );
      } else {
        print("StompClient is not connected. Attempting to reconnect...");
        WsStompConfig.stompClient.activate();
      }
    } catch (e) {
      print("[WsStompMessage.subscribe.catch] An Exception Occurred:\n $e");
    }
  }

  static void send(
      {required String chatId, required Map<String, dynamic> body}) {
    var path = '$send_path/$chatId/msg';
    WsStompConfig.stompClient.send(
      destination: path,
      body: jsonEncode(body),
    );
  }
}
