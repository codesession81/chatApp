import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/model_fields/member_fields.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/member.dart';
import 'package:example/services/time/getDateTime.dart';

class DbLogin{

  List<Member> _memberListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Member.fromJson(doc);
    }).toList();
  }

  Stream<List<Member>> getListAllMemberStream() => Collections.members.snapshots().map(_memberListFromSnapshot);

  Future setOnlineStatus(String? currentUserID, String status) async {
    await Collections.members.doc(currentUserID).update({
      '${MemberFields.onlineStatus}': status,
    });
  }

  Future setLoginDate(String? currentUserID) async {
    await Collections.members.doc(currentUserID).update({
      '${MemberFields.lastLoginDate}': GetDateTime.getDateTime().toString(),
    });
  }

  List<Like> _likeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Like.fromDocument(doc);
    }).toList();
  }

  Stream<List<Like>> currentUserLikeList({String? uid}) => 
    Collections.likes.doc(uid).collection(Collections.likesList).snapshots().map(_likeListFromSnapshot);

  List<Match> _matchListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Match.fromDocument(doc);
    }).toList();
  }

  Stream<List<Match>> currentUserMatchList({String? uid}) => Collections.matchs.doc(uid).collection(Collections.matchLists).snapshots()
        .map(_matchListFromSnapshot);
}