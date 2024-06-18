import 'dart:convert';
import 'dart:developer';

import 'package:mimichat/models/User.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class AuthDAO {
  static String _apiUrl = AppStateManager.apiURL + "/auth";

  static Future<User?> login(
      {required String email, required String password}) async {
    try {
      var body = jsonEncode({"email": email, "password": password});

      var response = await http.post(
        Uri.parse("$_apiUrl/login"),
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("[AuthDAO.login()] An Exception Occurred:\n ${e}");
      return null;
    }
  }

  static Future<User?> register(
      {required String username,
      required String email,
      required String password}) async {
    try {
      var body = {"username": username, "email": email, "password": password};
      var response = await http.post(
        Uri.parse("$_apiUrl/register"),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("[AuthDAO.register()] An Exception Occurred:\n ${e}");
      return null;
    }
  }
}
