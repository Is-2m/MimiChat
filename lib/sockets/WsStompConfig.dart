import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:provider/provider.dart';

class WsStompConfig {
  static const String WS_URL = 'ws://192.168.1.13:8080/ws';

  static final stompClient = StompClient(
  config: StompConfig(
    url: "ws://192.168.1.13:8080/ws",
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
  ),
);
}
