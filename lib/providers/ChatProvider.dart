import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';

class ChatProvider with ChangeNotifier {
  Chat? _selectedChat;
  bool _showChat = false;

  Chat get selectedChat => _selectedChat!;
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

  void addMessage(Message msg) {
    _selectedChat!.messages.add(msg);
    notifyListeners();
    return;
  }
}
