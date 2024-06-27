import 'dart:convert';

import 'package:mimichat/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager {
  // static int id = 130271211;
  // static String signIn =
  //     "a91961d9a72a5a8fe6aa2f70387b995ed7fbce67e4667e009206e515c89b52fa";

  static int VVCall_ID = 1137855613;
  static String VVCall_signIn =
      "715fd0ae2eda4f27f17d2dd5b32514ba58d3bfdf634794d841645b03e5f79026";

  static final String apiURL = "https://192.168.1.100:8443/api";
  static final String videoUrl = "https://192.168.1.100:8443/videocall.html";

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

  static setCache(SharedPreferences cache) {
    _cache = cache;
  }

  static Future<void> clearCache() async {
    await _cache!.clear();
    currentUser = null;
  }
}
