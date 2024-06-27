import 'package:mimichat/dao/CallHistoryDAO.dart';
import 'package:mimichat/models/CallHistory.dart';
import 'package:mimichat/models/CallState.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:url_launcher/url_launcher.dart';

class CallService {
  static String getCallURL(
      String roomId, String userId, String username, bool camera) {
    return "${AppStateManager.videoUrl}?roomID=$roomId&userID=$userId&username=$username&camera=$camera";
  }

  static Future<void> makeCall(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: "_blank",
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> updateCall(CallHistory call) async {
    call.state = CallState.ACCEPTED;
    await CallHistoryDAO.updateCall(call);
  }
}
