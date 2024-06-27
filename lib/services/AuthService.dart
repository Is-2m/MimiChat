import 'package:mimichat/dao/AuthDAO.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/utils/AppStateManager.dart';

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

 
}
