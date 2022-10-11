import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'match.g.dart';

@HiveType(typeId: 7)
class Match{
  @HiveField(0)
  final String? uid;
  @HiveField(1)
  final String? username;
  @HiveField(2)
  final String? profilImageURl;
  @HiveField(3)
  final num? counterNewMatchMsg;
  @HiveField(4)
  final String? message;
  @HiveField(5)
  final String? createdAt;
  @HiveField(6)
  final String? chatId;
  @HiveField(7)
  final bool? accountDeleted;
 

  Match({
    required this.uid,
    required this.username,
    required this.profilImageURl,
    required this.counterNewMatchMsg,
    required this.message,
    required this.createdAt,
    required this.chatId,
    required this.accountDeleted,
  });

  factory Match.fromDocument(DocumentSnapshot doc){
    return Match(
      uid: doc['uid'],
      username: doc['username'],
      profilImageURl: doc['profilImageURl'],
      counterNewMatchMsg: doc['counterNewMatchMsg'],
      message: doc['message'],
      createdAt: doc['createdAt'],
      chatId: doc['chatId'],
      accountDeleted: doc['accountDeleted'],
    );
  }
}