import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

class UserDAO {
  static String _apiUrl = AppStateManager.apiURL + "/users";

  static Future<User?> updateUser(User user) async {
    try {
      var body = jsonEncode(user.toJson());
      print(user);
      var response = await http.put(Uri.parse("$_apiUrl/${user.id}"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${AppStateManager.getToken()}"
          },
          body: body);

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
    // print(apiURL);
    try {
      Uint8List fileBytes = selectedImage.bytes!;

      String fileName =
          "User${userID}_${DateTime.now().toUtc().millisecondsSinceEpoch}.${selectedImage.extension}";
      String contentType = _getContentType(selectedImage.extension ?? '');


      var request = http.MultipartRequest('POST', Uri.parse(apiURL))
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
          contentType: http_parser.MediaType.parse(contentType),
        ))
        ..headers
            .addAll({"Authorization": "Bearer ${AppStateManager.getToken()}"});

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

  static String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<List<User>> searchUsersByName(String name) async {
    List<User> users = [];
    String url = "$_apiUrl/search/$name";
    Uri uri = Uri.parse(url);
    try {
      var response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AppStateManager.getToken()}"
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var userJs in data) {
          var user = User.fromJson(userJs);
          if (user.id != AppStateManager.currentUser!.id) {
            users.add(user);
          }
        }
      } else {
        print("UserDAO.searchUsersByName().else: ${response.body}");
      }
    } catch (e) {
      print("[UserDAO.searchUsersByName().catch]:\n$e");
    }
    return users;
  }
}
