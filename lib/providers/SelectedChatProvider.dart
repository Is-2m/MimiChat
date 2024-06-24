import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';

class SelectedChatProvider extends ChangeNotifier{
  String? _selectedChat;
  bool _showChat = false;


  String? get selectedChat => _selectedChat;
  bool get showChat => _showChat;

  void selectChat(String chatId) {
    _selectedChat = chatId;
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



}