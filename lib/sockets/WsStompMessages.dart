import 'dart:async';
import 'dart:convert';

import 'package:mimichat/models/CallHistory.dart';
import 'package:mimichat/sockets/WsStompConfig.dart';

class WsStompMessage {
  static final String new_subscrib_path = "/topic/notifications";
  static final String send_chat_path = "/app/chats";
  static final String send_call_path = "/app/calls";

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
            if (frame.body != null) {
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

  static void sendMessage(
      {required String chatId, required Map<String, dynamic> body}) {
    var path = '$send_chat_path/$chatId/msg';

    WsStompConfig.stompClient.send(
      destination: path,
      body: jsonEncode(body),
    );
  }

  static void sendCall({required CallHistory call}) {
    var path = send_call_path;
    var body = call.toJson();
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
