import 'package:flutter/material.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final bool isVideoCall;
  final String callID;

  const CallPage({required this.isVideoCall, required this.callID});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: AppStateManager.VVCall_ID,
      appSign: AppStateManager.VVCall_signIn,
      callID: callID,
      userID: AppStateManager.currentUser!.id,
      userName: AppStateManager.currentUser!.username,
      config: isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
