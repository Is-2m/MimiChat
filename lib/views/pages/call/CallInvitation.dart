import 'package:flutter/material.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationPage extends StatelessWidget {
  final Widget child;
  final String username;

  CallInvitationPage({
    required this.child,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCallWithInvitation(
      appID: AppStateManager.VVCall_ID,
      appSign: AppStateManager.VVCall_signIn,
      userID: username,
      userName: username,
      plugins: [ZegoUIKitSignalingPlugin()],
      child: child,
    );
  }
}
