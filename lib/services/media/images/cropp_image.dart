import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CroppImageFromDevice {

  Future imageCropper(File? file) async {
    File? cropped = await ImageCropper().cropImage(
        sourcePath:file!.path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Foto Ausrichten",
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.green[700],
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings(
        aspectRatioPickerButtonHidden:true,
    )
    );
    file = ((cropped ?? cropped!.path) as File?)!;
    return file;
  }

}