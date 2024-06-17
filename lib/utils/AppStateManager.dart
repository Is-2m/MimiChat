import 'dart:convert';

import 'package:mimichat/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager {
  static final String apiURL = "http://localhost:8080/api/";



  static SharedPreferences? _cache;
  static final String _currentUser_CacheName = "currentUser";
  static final String _CACHE_NAME = "app_state_cache";
  static User? currentUser;

  static saveCurrentUser(User user) {
    currentUser = user;
    _cache!.setString(_currentUser_CacheName, jsonEncode(user.toJson()));
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
