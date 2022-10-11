import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/data/consts/model_fields/member_fields.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'member.g.dart';

@HiveType(typeId: 9)
class Member{
  @HiveField(0)
  final String? uid;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final String? username;
  @HiveField(3)
  final String? gender;
  @HiveField(4)
  final String? age;
  @HiveField(5)
  final String? town;
  @HiveField(6)
  final String? profilImage;
  @HiveField(7)
  final String? onlineStatus;
  @HiveField(8)
  final String? lastLoginDate;
  @HiveField(9)
  final String? registerDate;
  @HiveField(10)
  final String? profilVerified;
  @HiveField(11)
  final String? profilVerifiedCode;
  @HiveField(12)
  final String? profilVerifiedImage;
  @HiveField(13)
  final String? profilVerificationStatus;
 

  Member({this.profilVerified,this.email,this.profilVerificationStatus,this.uid,this.profilVerifiedImage,this.username,this.gender,this.age,this.town,this.profilImage,this.lastLoginDate,this.onlineStatus,this.profilVerifiedCode,this.registerDate});

  factory Member.fromJson(DocumentSnapshot doc) {
    return Member(
      uid: doc.id,
      email: doc[MemberFields.email],
      username: doc[MemberFields.username],
      gender: doc[MemberFields.gender],
      age: doc[MemberFields.age],
      town: doc[MemberFields.town],
      profilImage: doc[MemberFields.profilImage],
      profilVerifiedImage: doc[MemberFields.profilVerifiedImage],
      lastLoginDate: doc[MemberFields.lastLoginDate],
      onlineStatus: doc[MemberFields.onlineStatus],
      profilVerified: doc[MemberFields.profilVerified],
      profilVerifiedCode: doc[MemberFields.profilVerifiedCode],
      registerDate: doc[MemberFields.registerDate].toString(),
      profilVerificationStatus: doc[MemberFields.profilVerificationStatus],
    );
  }
}