import 'dart:convert';

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

      print(response);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        AppStateManager.setToken(data["jwt"]);
        return User.fromJson(data["user"]);
      } else {
        return null;
      }
    } catch (e) {
      print("[AuthDAO.login().catch] An Exception Occurred:\n ${e}");
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

        AppStateManager.setToken(data["jwt"]);
        return User.fromJson(data["user"]);
      } else {
        print("[AuthDAO.register().else] An Error Occurred: ${response.body}");
        return null;
      }
    } catch (e) {
      print("[AuthDAO.register().catch] An Exception Occurred:\n ${e}");
      return null;
    }
  }

  static Future<void> logout(User user) async {
    var body = jsonEncode(user.toJson());
    print(body);
    try {
      var response = await http.post(
        Uri.parse("$_apiUrl/logout"),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );
      if (response.statusCode == 200) {
        return;
      } else {
        print("[AuthDAO.logout().else] An Error Occurred: ${response.body}");
        return;
      }
    } catch (e) {
      print("[AuthDAO.logout().catch] An Exception Occurred:\n ${e}");
      return;
    }
  }
}
