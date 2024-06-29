import 'dart:convert';

import 'package:mimichat/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager {
  static int VVCall_ID = 1137855613;
  static String VVCall_signIn =
      "715fd0ae2eda4f27f17d2dd5b32514ba58d3bfdf634794d841645b03e5f79026";

  static final String apiURL = "https://mimichat-backend.onrender.com/api";
  static final String videoUrl =
      "https://mimichat-backend.onrender.com/videocall.html";

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
