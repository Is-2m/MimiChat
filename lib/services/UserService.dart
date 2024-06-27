import 'package:file_picker/file_picker.dart';
import 'package:mimichat/dao/UserDAO.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/utils/AppStateManager.dart';

class UserService {
  static Future<bool> updateUserInfo(User user) async {
    bool isUpdated = false;
    await UserDAO.updateUser(user).then((val) {
      if (val != null) {
        AppStateManager.saveCurrentUser(val);
        isUpdated = true;
      }
    });
    return isUpdated;
  }

  static Future<String?> updateProfileImage(
      String userID, PlatformFile selectedImage) async {
    String? result = null;
    await UserDAO.updateProfilePicture(userID, selectedImage).then((val) {
      result = val;
      if (val != null) {
        User u = AppStateManager.currentUser!;
        u.profilePicture = val;
        AppStateManager.saveCurrentUser(u);
      }
    });
    return result;
  }

  static Future<List<User>> searchUsersByName(String name) async {
    List<User> users = [];
    await UserDAO.searchUsersByName(name).then((val) {
      users = val;
    });
    return users;
  }
}
