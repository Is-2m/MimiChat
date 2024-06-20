import 'dart:convert';

import 'package:mimichat/models/Message.dart';
import 'package:mimichat/models/User.dart';

class Chat {
  String id;
  User sender;
  User receiver;
  List<Message> messages;

  Chat({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: "${json['id']}",
        sender: User.fromJson(json['sender']),
        receiver: User.fromJson(json['receiver']),
        messages: json['messageList'] == null
            ? []
            : (json['messageList'] as List)
                .map((msg) => Message.fromJson(msg as Map<String, dynamic>))
                .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
      'messageList': messages.map((message) => message.toJson()).toList(),
    };
  }
}
