import 'dart:io';

import 'package:example/services/media/images/cropp_image.dart';
import 'package:example/services/media/images/image_compressor.dart';
import 'package:example/services/media/images/image_from_device.dart';
import 'package:image_picker/image_picker.dart';

class GetImageFromCamera{
   final PickImageFromDevice _pickImageFromDevice = PickImageFromDevice();
  final ImageCompressor _imageCompressor = ImageCompressor();
  final CroppImageFromDevice _croppImageFromDevice = CroppImageFromDevice();

  Future<File?> getImageFromCamera()async{
    File receivedImageFromCamera = await _pickImageFromDevice.pickSingleImageFromGallerieOrCamera(ImageSource.camera);
    File receivedCroppedImage = await _croppImageFromDevice.imageCropper(receivedImageFromCamera);
    File? compressedFile = (await _imageCompressor.compressFile(receivedCroppedImage));
    return compressedFile;
  }
}