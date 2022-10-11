import 'dart:io';

import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/model_fields/member_fields.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/services/media/images/upload_file_to_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class DbUpdateProfileData{

  Future uploadNewProfilImage(String? userId,File file)async{
    final fileName = basename(file.path);
    final destination = 'profilImages/$userId/$fileName';
    final fileUrl = await UploadFileToStorage.uploadFile(destination,file);  
    await Collections.members.doc(userId).update({
      MemberFields.profilImage: fileUrl
    });
  }

  Future uploadProfilVerificationImage(String? currentUserId,File file)async{
    final fileName = basename(file.path);
    final destination = 'profilVerificationImage/$currentUserId/$fileName';
    final fileUrl = await UploadFileToStorage.uploadFile(destination,file);
    await Collections.members.doc(currentUserId).update({
      MemberFields.profilImage: fileUrl
    });
  }

  Future setProfilVerificationState()async{
    await Collections.members.doc(GlobalData.currentUser?.uid).update({
      MemberFields.profilVerificationStatus: "check"
    });
  }

  Future saveProfilVerificationCode(String profilVerificationCode)async{
    await Collections.members.doc(GlobalData.currentUser?.uid).update({
      MemberFields.profilVerifiedCode:profilVerificationCode
    });
  }

  Future deleteUser(User? user) async {
     FirebaseStorage.instance.refFromURL("profilImages/${user?.uid}/${user?.uid}").delete();
     Collections.members.doc(user?.uid).delete();
     user?.delete();
  }

  Future updateTown({String? town})async{
     await Collections.members.doc(GlobalData.currentUser?.uid).update({
      MemberFields.town: town,
     });
  }

  Future updateGender({String? gender})async{
     await Collections.members.doc(GlobalData.currentUser?.uid).update({
         MemberFields.gender: gender,
     });
  }

}