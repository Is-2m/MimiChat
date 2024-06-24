import 'package:flutter/material.dart';
import 'package:mimichat/dao/ChatDAO.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:mimichat/providers/SelectedChatProvider.dart';
import 'package:mimichat/sockets/WsStompMessages.dart';
import 'package:provider/provider.dart';

class ChatService {
  static Future<List<Chat>> getChats(
      {required String userId, required BuildContext ctx}) async {
    List<Chat> chats = [];
    await ChatDao.getChats(userId: userId).then((val) {
      chats = val;
      ctx.read<ChatsProvider>().addChats(chats);

      chats.forEach((chat) {
        WsStompMessage.subscribe(
          chatId: chat.id,
          onMessageReceived: (chatId, message) {
            Provider.of<ChatsProvider>(ctx, listen: false)
                .addMessage(chatId, message);
            // Provider.of<SelectedChatProvider>(ctx, listen: false)
            //     .addMessageToCurrent(message);
          },
        );
      });
    });
    return chats;
  }
}
