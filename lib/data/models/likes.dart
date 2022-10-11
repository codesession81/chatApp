import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'likes.g.dart';

@HiveType(typeId: 6)
class Like{
  @HiveField(0)
  final bool? likeValue;
  @HiveField(1)
  final String? uid;

  Like({required this.likeValue,required this.uid});

  factory Like.fromDocument(DocumentSnapshot doc){
    return Like(
        likeValue: doc['likeValue'],
        uid: doc.id,
    );
  }
}