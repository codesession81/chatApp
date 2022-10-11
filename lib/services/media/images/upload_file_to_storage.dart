import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFileToStorage{

  static Future<String> uploadFile(String destination,File file)async{
    final ref = FirebaseStorage.instance.ref(destination);
    final result = await ref.putFile(file);
    final String fileUrl = (await result.ref.getDownloadURL());
    return fileUrl;
  }
}