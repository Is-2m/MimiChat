import 'package:mimichat/dao/AuthDAO.dart';
import 'package:mimichat/dao/MessageWebSocket.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class AuthService {
  static Future<User?> login(String email, String password) async {
    User? user;
    try {
      await AuthDAO.login(email: email, password: password).then((value) {
        user = value;
        AppStateManager.saveCurrentUser(user!);
      });
      return user;
    } catch (e) {
      print("[AuthService.login().catch] An Exception Occurred:\n ${e}");
      return null;
    }
  }

  static Future<User?> register(
      String username, String email, String password) async {
    User? user;
    await AuthDAO.register(username: username, email: email, password: password)
        .then((value) {
      user = value;
      AppStateManager.saveCurrentUser(user!);
    });
    return user;
  }

  static Future<void> logout(User user) async {
    await AuthDAO.logout(user);
    await AppStateManager.clearCache();
  }

  static void onUserLogin() {
    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1137855613 /*input your AppID*/,
      appSign:
          "715fd0ae2eda4f27f17d2dd5b32514ba58d3bfdf634794d841645b03e5f79026" /*input your AppSign*/,
      userID: AppStateManager.currentUser!.id,
      userName: AppStateManager.currentUser!.username,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        /// custom avatar
        // config.avatarBuilder = customAvatarBuilder;

        /// support minimizing, show minimizing button
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons
            .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
        config.topMenuBar.buttons
            .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);

        return config;
      },
    );
  }
}
