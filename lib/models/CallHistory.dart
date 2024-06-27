import 'package:mimichat/models/CallState.dart';
import 'package:mimichat/models/User.dart';

class CallHistory {
  String? id;
  User caller;
  User receiver;
  DateTime date;
  int duration;
  CallState state;
  String roomId;

  CallHistory({
    this.id = "",
    required this.caller,
    required this.receiver,
    required this.date,
    this.duration = 0,
    required this.state,
    required this.roomId,
  });

  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      id: "${json['id']}",
      date: DateTime.fromMillisecondsSinceEpoch(int.parse("${json['date']}"),
          isUtc: true),
      duration: json['duration'],
      state: json['state'] == "MISSED"
          ? CallState.MISSED
          : json['state'] == "ACCEPTED"
              ? CallState.ACCEPTED
              : CallState.None,
      roomId: json["roomId"],
      caller: User.fromJson(json['caller']),
      receiver: User.fromJson(
        json['receiver'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caller': caller,
      'receiver': receiver,
      'date': date.toUtc().millisecondsSinceEpoch,
      'duration': duration,
      'state': state.name,
      'roomId': roomId,
    };
  }

  @override
  String toString() {
    return 'CallHistory{id: $id, caller: $caller, receiver: $receiver, date: $date, duration: $duration, state: $state, roomId: $roomId}';
  }
}
