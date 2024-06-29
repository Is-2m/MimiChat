import 'package:stomp_dart_client/stomp_dart_client.dart';

class WsStompConfig {
  static const String WS_URL = 'wss://mimichat-backend.onrender.com/ws';

  static final stompClient = StompClient(
    config: StompConfig(
      url: WsStompConfig.WS_URL,
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(const Duration(milliseconds: 200));
        print('connecting...');
      },
      onWebSocketError: (dynamic error) {
        print('onWebSocketError:\n${error.toString()}');
      },
      onStompError: (p0) => print('onStompError: $p0'),
      onDisconnect: (f) => print('Disconnected'),
      onConnect: (p0) => print('Connected!'),
    ),
  );
}
