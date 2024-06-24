import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';

class ChatsProvider extends ChangeNotifier {
  List<Chat> lstChats = List.empty(growable: true);

  void addMessage(String chatId, Message msg) {
    final chat = lstChats.firstWhere((element) => element.id == chatId);
    chat.messages.add(msg);
    notifyListeners();
    return;
  }

  void addChat(Chat chat) {
    lstChats.add(chat);
    notifyListeners();
    return;
  }

  void addChats(List<Chat> chats) {
    lstChats.clear();
    lstChats.addAll(chats);
    notifyListeners();
    return;
  }

  Chat getCurrentChat(String chatId) {
    return lstChats.firstWhere((element) => element.id == chatId);
  }
}
