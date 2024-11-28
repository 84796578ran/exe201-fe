import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class ImageHelper {
  static Future<List<File>> pickImages({int maxImages = 3}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (files.length > maxImages) {
          Get.snackbar(
            'Warning',
            'Maximum $maxImages images allowed',
            snackPosition: SnackPosition.BOTTOM,
          );
          return files.sublist(0, maxImages);
        }
        return files;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return [];
  }
} 