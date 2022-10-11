import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickImageFromDevice{

  Future pickSingleImageFromGallerieOrCamera(ImageSource source) async {
    File? _file;
    try{
      final image = await ImagePicker().pickImage(
        source: source,
        );
      if(image!=null){
        _file =File(image.path);
      }
      return _file;
    }on PlatformException catch(e){
      print("Failed to pick image $e");
    }
  }

  Future<List<XFile>?> selectMultipleImagesFromGallerie()async{
  List<XFile> _imageFileList =[];
  try{
    final images= await ImagePicker().pickMultiImage();
    print(images?.first.path);
    _imageFileList.clear();
    _imageFileList.addAll(images!);
    return _imageFileList;
  }on PlatformException catch(e){
    print("Failed to get images from gallerie $e");
  }
  }
}