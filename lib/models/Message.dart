import 'package:mimichat/models/User.dart';

class Message {
  String? id;
  // String idChat;
  String content;
  User sender;
  User receiver;
  DateTime date;

  Message({
    this.id,
    // required this.idChat,
    required this.content,
    required this.date,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: "${json['id']}",
      // idChat: "${json}",
      content: json['content'],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse("${json['date']}"),
          isUtc: true),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'chat': chat.toJson(),
      'content': content,
      'date': date.toUtc().millisecondsSinceEpoch,
      'sender': sender,
      'receiver': receiver,
    };
  }

  // User get owner {
  //   return idSender == chat.sender.id ? chat.sender : chat.receiver;
  // }
}
