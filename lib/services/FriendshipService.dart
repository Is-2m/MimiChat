import 'package:mimichat/dao/FriendshipDAO.dart';
import 'package:mimichat/models/Friendship.dart';

class FriendshipService {
  static Future<List<Friendship>> getFriendshipsByUserId(String id) async {
    List<Friendship> friendships = [];
    await FirendshipDAO.getFriendshipsByUserId(id).then((val) {
      friendships = val;
    });
    return friendships;
  }
}
