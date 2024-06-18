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

      var request =
          http.MultipartRequest('POST', Uri.parse("${_apiURL}/upload/$userID"))
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

  static Future<Uint8List?> getImage(String filename) async {
    try {
      final response = await http.get(Uri.parse("$_apiURL/$filename"));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
