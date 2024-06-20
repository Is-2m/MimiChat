import 'package:mimichat/models/Status.dart';

class User {
  String id;
  String? firstName;
  String? lastName;
  String email;
  String password;
  String username;
  String? phone;
  String? bio;
  String? birthDate;
  String? profilePicture = "";
  Status? status;

  User({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.password = "",
    this.username = "",
    this.phone = "",
    this.bio = "",
    this.birthDate = "",
    this.profilePicture = "",
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: "${json['id']}",
      firstName: "${json['firstName'] ?? null}",
      lastName: "${json['lastName'] ?? null}",
      email: "${json['email']}",
      phone: "${json['phone'] ?? null}",
      bio: "${json['bio'] ?? null}",
      password: "${json['password']}",
      username: "${json['username']}",
      birthDate: "${json['birthDate'] ?? null}",
      profilePicture: "${json['profilePicture'] ?? null}",
      status: json['status'] == null
          ? null
          : json['status'] == Status.OFFLINE.name
              ? Status.OFFLINE
              : Status.ONLINE,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'bio': bio,
      'password': password,
      'username': username,
      'birthDate': birthDate,
      'profilePicture': profilePicture,
      'status': status?.name,
    };
  }

  String get fullName {
    return "${firstName ?? "-"} ${lastName ?? "-"}";
  }

  bool isSamePersonAs(User user) {
    return this.id == user.id;
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, username: $username, phone: $phone, bio: $bio, birthDate: $birthDate, profilePicture: $profilePicture}';
  }
}
