import 'package:mimichat/models/CallState.dart';
import 'package:mimichat/models/User.dart';

class CallHistory {
  String id;
  User caller;
  User receiver;
  DateTime date;
  int duration;
  CallState state;

  CallHistory({
    this.id = "",
    required this.caller,
    required this.receiver,
    required this.date,
    required this.duration,
    required this.state,
  });

  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      id: "${json['id']}",
      caller: User.fromJson(json['caller']),
      receiver: User.fromJson(json['receiver']),
      date: DateTime.fromMillisecondsSinceEpoch(int.parse("${json['date']}"),
          isUtc: true),
      duration: json['duration'],
      state: CallState.values[json['state']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caller': caller,
      'receiver': receiver,
      'date': date.toUtc().millisecondsSinceEpoch,
      'duration': duration,
      'state': state.index,
    };
  }

  @override
  String toString() {
    return 'CallHistory{id: $id, caller: $caller, receiver: $receiver, date: $date, duration: $duration, state: $state}';
  }
}
