import 'package:mimichat/utils/AppStateManager.dart';

class CallService {
  static String getCallUrl(
      String callId, String userId, String username, bool camera) {
    return "${AppStateManager.videoUrl}?roomiD=$callId&userID=$userId&username=$username&camera=$camera";
  }
}
