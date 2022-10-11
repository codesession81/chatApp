import 'package:example/data/models/member.dart';

class IsEmailUnkwown{

  bool isEmailUnknown(List<Member>? allMembers,String email){
   bool emailExists=false;
   allMembers?.forEach((memberEmail) {
       if(memberEmail.email== email){
        emailExists= true;
      }
   });
   return emailExists;
  }
}