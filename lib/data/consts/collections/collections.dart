import 'package:cloud_firestore/cloud_firestore.dart';

class Collections{

  //Collections
  static final CollectionReference members = FirebaseFirestore.instance.collection('members');
  static final CollectionReference likes = FirebaseFirestore.instance.collection('likes');
  static final CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  static final CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  

  //SubCollections
  static const String chatList ="chatList";
  static const String likesList ="likesList";
  static const String matchLists ="matchLists";
  static const String listOfGroups = "listOfGroups";
}