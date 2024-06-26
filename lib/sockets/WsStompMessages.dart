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
  static final String new_subscrib_path = "/topic/notifications";
  static final String send_path = "/app/chats";

  // static void subscribe({
  //   required String chatId,
  //   required Function(String chatId, Message message) onMessageReceived,
  // }) {
  //   try {
  //     if (WsStompConfig.stompClient.connected) {
  //       var path = "$subscrib_path/$chatId/msg";
  //       WsStompConfig.stompClient.subscribe(
  //         destination: path,
  //         callback: (frame) {
  //           if (frame.body != null) {
  //             final chatId = frame.headers['destination']?.split('/')[3];
  //             if (chatId != null) {
  //               final message = Message.fromJson(jsonDecode(frame.body!));
  //               onMessageReceived(chatId, message);
  //             }
  //           }
  //         },
  //       );
  //     } else {
  //       print("StompClient is not connected. Attempting to reconnect...");
  //       WsStompConfig.stompClient.activate();
  //     }
  //   } catch (e) {
  //     print("[WsStompMessage.subscribe.catch] An Exception Occurred:\n $e");
  //   }
  // }

  static void newSubscribe({
    required String userID,
    required Function(String body) onDataReceived,
  }) async {
    try {
      await ensureStompConnection();

      var path = "$new_subscrib_path/$userID";
      print("[WsStompMessages.newSub] path: $path");

      if (WsStompConfig.stompClient.connected) {
        WsStompConfig.stompClient.subscribe(
          destination: path,
          callback: (frame) {
            if (frame.body != null  ) {
              onDataReceived(frame.body!);
            }
          },
        );
      } else {
        print("Cannot set up subscriptions as StompClient is not connected.");
      }
    } catch (e) {
      print("[New WsStompMessage.subscribe.catch] An Exception Occurred:\n $e");
    }
  }

  static void send(
      {required String chatId, required Map<String, dynamic> body}) {
    var path = '$send_path/$chatId/msg';

    // print("[WsStompMessages.send()] path: $path");
    // print("[WsStompMessages.send()] body: ${json.encode(body)}");
    WsStompConfig.stompClient.send(
      destination: path,
      body: jsonEncode(body),
    );
  }

  static Future<void> ensureStompConnection() async {
    int retryCount = 0;
    const maxRetries = 5;
    const initialDelay = Duration(seconds: 1);

    while (!WsStompConfig.stompClient.connected && retryCount < maxRetries) {
      try {
        print(
            "Attempting to connect StompClient (Attempt ${retryCount + 1})...");
        WsStompConfig.stompClient.activate();

        if (WsStompConfig.stompClient.connected) {
          print("StompClient connected successfully.");
          return;
        }
      } catch (e) {
        print("Error connecting StompClient: $e");
      }

      retryCount++;
      if (retryCount < maxRetries) {
        final delay = initialDelay * (2 ^ retryCount); // Exponential backoff
        print("Waiting for ${delay.inSeconds} seconds before next attempt...");
        await Future.delayed(delay);
      }
    }

    if (!WsStompConfig.stompClient.connected) {
      print("Failed to connect StompClient after $maxRetries attempts.");
      // Handle the failure (e.g., show an error message to the user)
    } else {
      print("[ensureStompConnection] Connected Succfully");
    }
  }
}
