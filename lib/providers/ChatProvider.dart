import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';

class ChatProvider extends ChangeNotifier {
  Chat? _selectedChat;
  bool _showChat = false;

  List<Chat> lstChats = List.empty(growable: true);

  Chat? get selectedChat => _selectedChat;
  bool get showChat => _showChat;

  void selectChat(Chat chat) {
    _selectedChat = chat;
    _showChat = true;
    notifyListeners();
    return;
  }

  void closeChat() {
    _selectedChat = null;
    _showChat = false;
    notifyListeners();
    return;
  }

  void addMessageToCurrent(Message msg) {
    _selectedChat!.messages.add(msg);
    notifyListeners();
    return;
  }

  void addMessage(String chatId, Message msg) {
    final chat = lstChats.firstWhere((element) => element.id == chatId);
    chat.messages.add(msg);
    notifyListeners();
    return;
  }

  void addChat(Chat chat) {
    lstChats.clear();
    lstChats.add(chat);
    notifyListeners();
    return;
  }

  void addChats(List<Chat> chats) {
    lstChats.addAll(chats);
    notifyListeners();
    return;
  }
}
