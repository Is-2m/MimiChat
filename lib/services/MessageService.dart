import 'package:mimichat/dao/MessageDAO.dart';
import 'package:mimichat/models/Message.dart';

class MessageService {
  static Future<Message?> sendMessage(String chatID, Message msg) async {
    Message? newMessage;
    await MessageDAO.saveMessage(chatID, msg).then((val) {
      newMessage = val;
    });
    return newMessage;
  }
}
