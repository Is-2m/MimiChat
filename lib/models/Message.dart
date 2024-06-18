import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/User.dart';

class Message {
  String id;
  // String idChat;
  String content;
  String idSender;
  String idReceiver;
  DateTime date;

  Message({
    required this.id,
    // required this.idChat,
    required this.content,
    required this.date,
    required this.idSender,
    required this.idReceiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: "${json['id']}",
      // idChat: "${json}",
      content: json['content'],
      date: DateTime.parse("${json['date']}"),
      idSender: "${json['id_sender']}",
      idReceiver: "${json['id_receiver']}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'chat': chat.toJson(),
      'content': content,
      'date': date.toUtc().millisecondsSinceEpoch,
      'id_sender': idSender,
      'id_receiver': idReceiver,
    };
  }

  // User get owner {
  //   return idSender == chat.sender.id ? chat.sender : chat.receiver;
  // }
}
