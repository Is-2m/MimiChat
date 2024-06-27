import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';

class ChatsProvider extends ChangeNotifier {
  List<Chat> lstChats = List.empty(growable: true);

  void addMessage(String chatId, Message msg) {
    final chat = lstChats.firstWhere((element) => element.id == chatId);

    bool contains = false;
    for (var i = chat.messages.length - 1; i >= 0; i--) {
      if (chat.messages[i].isSameMsgAs(msg)) {
        contains = true;
        break;
      }
    }

    print("Contains is $contains");

    if (!contains) {
      print("[In if]");

      chat.messages.add(msg);
      print("Message Added: ${chat.messages.last} ");
      notifyListeners();
    }
    return;
  }

  void addChat(Chat chat) {
    if (!lstChats.any((element) => element.id == chat.id)) {
      lstChats.add(chat);
      notifyListeners();
    }
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
