import 'dart:convert';

import 'package:mimichat/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager {
  static int VVCall_ID = 1076254653;
  static String VVCall_signIn =
      "7a5a56e4b40a6cb280eaf753104954f0f75380cd6a3386c56c79ab7dab317cbd";

  static final String apiURL = "$protocol://$HOST/api";
  static final String videoUrl = "$protocol://$HOST/videocall.html";

  static final String protocol = "https";
  static final String socketUrl = "wss://$HOST/ws";
  static final String HOST = "mimichat-backend.onrender.com";

  static SharedPreferences? _cache;
  static final String _currentUser_CacheName = "currentUser";
  static final String _CACHE_NAME = "app_state_cache";

  static User? currentUser;

  static saveCurrentUser(User? user) {
    if (user != null) {
      currentUser = user;
      _cache!.setString(_currentUser_CacheName, jsonEncode(user.toJson()));
    } else {
      currentUser = null;
      _cache!.setString(_currentUser_CacheName, "null");
    }
  }

  static Future<User?> getCurrentUser() async {
    if (currentUser != null) {
      return currentUser;
    }
    String? userJson = _cache!.getString(_currentUser_CacheName);
    if (userJson == null) {
      return null;
    }
    Map<String, dynamic> userMap =
        Map<String, dynamic>.from(jsonDecode(userJson));
    currentUser = User.fromJson(userMap);
    return currentUser;
  }

  static setToken(String token) {
    _cache!.setString("token", token);
  }

  static getToken() {
    return _cache!.getString("token");
  }

  static setCache(SharedPreferences cache) {
    _cache = cache;
  }

  static Future<void> clearCache() async {
    await _cache!.clear();
    currentUser = null;
  }
}
