import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mimichat/dao/ImageDAO.dart';

class ImageService {
  static Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    return result!.files.first;
  }

  // static Future<String?> uploadImage(String userID, PlatformFile selectedImage) async {
  //   String? result = null;
  //   await ImageDAO.uploadFile(userID, selectedImage).then((val) {
  //     result = val;

  //   });
  //   return result;
  // }

  static Future<Uint8List?> getImage(String filename) async {
    Uint8List? result;
    await ImageDAO.getImage(filename).then((val) {
      result = val;
    });
    return result;
  }
}
