import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/member.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Cache {
  
   static Future loadingCurrentUserLikesStreamInLocalDb(List<Like> currentUserLikesList)async{
    await Hive.openBox(HiveBoxes.likesBox);
    await Hive.box(HiveBoxes.likesBox).clear();
    await Hive.box(HiveBoxes.likesBox).addAll(currentUserLikesList);
  }

  static Future loadingCurrentUserMatchsStreamInLocalDb(List<Match> currentUserMatchList)async{
    await Hive.openBox(HiveBoxes.matchsBox);
    await Hive.box(HiveBoxes.matchsBox).clear();
    await Hive.box(HiveBoxes.matchsBox).addAll(currentUserMatchList);
    GlobalData.currentUserMatchList = currentUserMatchList.cast<Match>();
  }

  static Future loadingMemberStreamInLocalDb(List<Member> listAllMembers)async{
    await Hive.openBox(HiveBoxes.allMembersBox);
    await Hive.box(HiveBoxes.allMembersBox).clear();
    await Hive.box(HiveBoxes.allMembersBox).addAll(listAllMembers);
  }


}