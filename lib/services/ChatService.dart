import 'package:mimichat/dao/ChatDAO.dart';
import 'package:mimichat/models/Chat.dart';

class ChatService {
  static Future<List<Chat>> getChats(String userId) async {
    List<Chat> chats = [];
    await ChatDao.getChats(userId: userId).then((val) {
      chats = val;
    });
    return chats;
  }
}
