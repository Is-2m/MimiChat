import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class UserDAO {
  static String _apiUrl = AppStateManager.apiURL + "/users";

  static Future<User?> updateUser(User user) async {
    try {
      var body = jsonEncode(user.toJson());
      print(user);
      var response = await http.put(Uri.parse("$_apiUrl/${user.id}"),
          headers: {"Content-Type": "application/json"}, body: body);

      print("response.body: ${response.body}\nBody: $body");
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print("UserDAO.updateUser():\n$e");
      return null;
    }
  }

  static Future<String?> updateProfilePicture(
      String userID, PlatformFile selectedImage) async {
    String apiURL = "${AppStateManager.apiURL}/profile-pictures/upload/$userID";
    print(apiURL);
    try {
      Uint8List fileBytes = selectedImage.bytes!;
      String fileName =
          "User${userID}_${DateTime.now().toUtc().millisecondsSinceEpoch}.png";

      var request = http.MultipartRequest('POST', Uri.parse(apiURL))
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully.');
        return fileName;
      } else {
        print('File upload failed.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
