import 'package:flutter/material.dart';
import 'package:mimichat/models/CallHistory.dart';

class CallProvider extends ChangeNotifier {
  CallHistory? incomingCall;

  void addIncomingCall(CallHistory call) {
    if (incomingCall != null) {
      incomingCall = call;
      notifyListeners();
    }
    return;
  }
}
