import 'package:flutter/material.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallInvitationPage extends StatelessWidget {
  final Widget child;
  final String username;

  CallInvitationPage({
    required this.child,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    return ZegoUIKitPrebuiltCall(
        appID: AppStateManager.VVCall_ID,
        appSign: AppStateManager.VVCall_signIn,
        callID: uuid.v4(),
        userID: AppStateManager.currentUser!.id,
        userName: AppStateManager.currentUser!.username,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),);
    // var a = ZegoUIKitPrebuiltCallWithInvitation(
    //   appID: AppStateManager.VVCall_ID,
    //   appSign: AppStateManager.VVCall_signIn,
    //   userID: username,
    //   userName: username,
    //   plugins: [ZegoUIKitSignalingPlugin()],
    //   child: child,
    // );
  }
}
