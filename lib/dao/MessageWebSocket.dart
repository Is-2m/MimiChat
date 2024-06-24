import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class MessageWebSocket {
  final String _url = 'ws://192.168.1.100:8080';
  late WebSocketChannel channel;

  void connect(String userId) {
    channel = WebSocketChannel.connect(Uri.parse(_url));
    channel.stream.listen((message) {
      _onMessageReceived(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });

    // Subscribe to user's private messages
    _subscribeToUserPrivateMessages(userId);
  }

  void _subscribeToUserPrivateMessages(String userId) {
    // Subscribe to user-specific private message queue if necessary
  }

  void subscribeToPrivateChat(String chatId) {
    var subscribeMessage = jsonEncode({
      'type': 'subscribe',
      'channel': '/topic/private/' + chatId,
    });
    channel.sink.add(subscribeMessage);
  }

  void sendPrivateMessage(
      String chatId, String content, String senderId, String receiverId) {
    var message = jsonEncode({
      'chat': {'id': chatId},
      'id_sender': senderId,
      'id_receiver': receiverId,
      'content': content,
      'date': DateTime.now().toUtc().millisecondsSinceEpoch,
    });
    channel.sink.add(message);
  }

  void _onMessageReceived(String message) {
    var decodedMessage = jsonDecode(message);
    print('Message received: $decodedMessage');
    // Add logic to update UI or handle the message
  }

  void dispose() {
    channel.sink.close(status.goingAway);
  }
}
