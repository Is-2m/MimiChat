class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String username;
  String phone;
  String bio;
  String birthDate;
  String profilePicture = "";

  User({
    this.id = "",
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.username,
    this.phone = "",
    this.bio = "",
    this.birthDate = "",
    this.profilePicture = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      password: json['password'],
      username: json['username'],
      birthDate: json['birthDate'],
      profilePicture: json['profilePicture'],
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
    };
  }
}
