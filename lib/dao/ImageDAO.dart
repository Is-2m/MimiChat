import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:http/http.dart' as http;

class ImageDAO {
  static final String _apiURL = "${AppStateManager.apiURL}/profile-pictures";

  static Future<String?> uploadFile(
      String userID, PlatformFile selectedImage) async {
    try {
      Uint8List fileBytes = selectedImage.bytes!;
      String fileName =
          "User${userID}_${DateTime.now().toUtc().millisecondsSinceEpoch}.png";

      var request = http.MultipartRequest(
          'POST', Uri.parse("${_apiURL}/upload/$userID"))
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
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

  static Future<Uint8List?> getImage(String filename) async {
    try {
      final response = await http.get(Uri.parse(filename));

      if (response.statusCode == 200) {
        String? contentType = response.headers['content-type'];
        if (contentType != null && contentType.startsWith('image/')) {
          return response.bodyBytes;
        } else {
          print('Received content is not an image. Content-Type: $contentType');
          // print(response.body);
          return null;
        }
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
