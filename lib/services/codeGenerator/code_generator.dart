import 'dart:math';

import 'package:example/data/database/online/db_update_profile_data.dart';

class CodeGenerator {

  static Future generateVerificationCode({String? profilVerifiedCode}) async{
    final DbUpdateProfileData _dbUpdateProfileData = DbUpdateProfileData();
    if(profilVerifiedCode==""){
      String generatedCode = Random().nextInt(9999).toString().padLeft(4, '0');
      await _dbUpdateProfileData.saveProfilVerificationCode(generatedCode);
    }
  }
}