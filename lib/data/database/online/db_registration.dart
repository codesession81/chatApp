import 'dart:io';

import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/model_fields/member_fields.dart';
import 'package:example/services/media/images/upload_file_to_storage.dart';
import 'package:example/services/time/getDateTime.dart';
import 'package:path/path.dart';

class DbRegistration{

  Future uploadProfilImageToFirebaseStorage({String? userId, String? email, String? username, File? file, String? timestamp,String? age,String? gender,String? town}) async {
    if(file==null) return;
    final fileName = basename(file.path);
    final destination = 'profilImages/$userId/$fileName';
    final profilImage = await UploadFileToStorage.uploadFile(destination,file);
    setMemberRegistrationData(uid:userId,email:email,username:username,profilImage:profilImage,age:age,gender:gender,town: town);
  }

  Future setMemberRegistrationData({String? uid, String? email, String? username, String? profilImage,String? age,String? gender,String? town}) async {
    await Collections.members.doc(uid).set({
      '${MemberFields.uid}': uid,
      '${MemberFields.email}': email,
      '${MemberFields.username}': username,
      '${MemberFields.gender}': gender,
      '${MemberFields.age}': age,
      '${MemberFields.town}': town,
      '${MemberFields.profilImage}': profilImage,
      '${MemberFields.onlineStatus}': 'online',
      '${MemberFields.lastLoginDate}': '',
      '${MemberFields.profilVerified}': false,
      '${MemberFields.profilVerifiedCode}': '',
      '${MemberFields.profilVerifiedImage}': '',
      '${MemberFields.registerDate}': GetDateTime.getDateTime().toString(),
      '${MemberFields.profilVerificationStatus}':'offen',
      '${MemberFields.lastModified}':GetDateTime.getDateTime().toString(),
    });
  }

  Future updateCurrentUserEmail(String userId, String email) async {
    await Collections.members.doc(userId).update({'${MemberFields.email}': email});
  }
}