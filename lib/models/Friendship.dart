import 'package:mimichat/models/User.dart';

class Friendship {
  String? id;
  User sender;
  User receiver;
  FriendshipState state;
  DateTime date;

  Friendship(
      {this.id,
      required this.sender,
      required this.receiver,
      required this.state,
      required this.date});

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      id: "${json['_id']}",
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
      state: json['state'] == "PENDING"
          ? FriendshipState.PENDING
          : json['state'] == "ACCEPTED"
              ? FriendshipState.ACCEPTED
              : json['state'] == "DENIED"
                  ? FriendshipState.DENIED
                  : FriendshipState.None,
      date: DateTime.fromMillisecondsSinceEpoch(int.parse("${json['date']}"),
          isUtc: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
      'state': state.name,
      'date': date.toUtc().millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Friendship{id: $id, state: $state, date: $date, sender: $sender, receiver: $receiver, }';
  }
}

enum FriendshipState { PENDING, ACCEPTED, DENIED, None }
