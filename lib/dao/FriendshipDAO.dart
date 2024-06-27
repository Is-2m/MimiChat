import 'dart:convert';

import 'package:mimichat/models/Friendship.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class FirendshipDAO {
  static final String _localURL = "${AppStateManager.apiURL}/friendship";

  static Future<List<Friendship>> getFriendshipsByUserId(String id) async {
    List<Friendship> friendships = [];
    String url = "$_localURL/$id";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonFriendships = jsonDecode(response.body);
        for (var jsonFriendship in jsonFriendships) {
          friendships.add(Friendship.fromJson(jsonFriendship));
        }
      } else {
        print(
            "[FriendshipDAO.getFriendshipsByUserId()]: Failed to get friendships");
      }
    } catch (e) {
      print("FriendshipDAO.getFriendshipsByUserId():\n$e");
    }
    return friendships;
  }
}
