import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor{
  Future<File> compressFile(File file) async {
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path, outPath,
      quality: 40,
    );
    return result!;
  }
}