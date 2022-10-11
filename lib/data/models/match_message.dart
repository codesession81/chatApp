import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'match_message.g.dart';

@HiveType(typeId: 8)
class MatchMessage{
  @HiveField(0)
  final String? message;
  @HiveField(1)
  final String? senderId;
  @HiveField(2)
  final String? senderUsername;
  @HiveField(3)
  final String? senderProfilImageURl;
  @HiveField(4)
  final String? createdAt;
  @HiveField(5)
  final bool? isDeleted;
  @HiveField(6)
  final String? msgType;

  MatchMessage({this.msgType,this.isDeleted,this.createdAt,this.message, this.senderId, this.senderUsername, this.senderProfilImageURl});

  factory MatchMessage.fromDocument(DocumentSnapshot doc){
    return MatchMessage(
      message: doc['message'],
      senderId: doc['senderId'],
      senderUsername: doc['senderUsername'],
      senderProfilImageURl: doc['senderProfilImageURl'],
      createdAt: doc['createdAt'],
      isDeleted: doc['isDeleted'],
      msgType: doc['msgType'],
    );
  }
}