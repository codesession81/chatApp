import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/offline/cache.dart';
import 'package:example/data/database/online/db_login.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/pages/private/navigationsScreens/members/show_all_members.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class Members extends StatefulWidget {
  final User? user;
  Members({required this.user});

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final DbLogin _dbLogin = DbLogin();
  List<Member> memberListNoCurrentUser = [];
  TextEditingController friendSearchController = TextEditingController();
  Member? searchFriendsResult;


 


  @override
  Widget build(BuildContext context) {
    final currentUserLikesList = Provider.of<List<Like>>(context);
    final currentUserMatchList = Provider.of<List<Match>>(context);

    Cache.loadingCurrentUserMatchsStreamInLocalDb(currentUserMatchList);
    Cache.loadingCurrentUserLikesStreamInLocalDb(currentUserLikesList);

    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
        builder: (context, box, _) {
          var allMemberList = box.values.toList().cast<Member>();
          GlobalData.allMember = allMemberList;
          memberListNoCurrentUser.clear();
          allMemberList.forEach((member) {
            if (member.uid != widget.user?.uid) {
              memberListNoCurrentUser.add(member);
            }else if(member.uid == widget.user?.uid){
              GlobalData.currentUser = member;
            }
          });
          return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.white,
               
              ),
              body: ShowAllMembers(memberListNoCurrentUser: memberListNoCurrentUser)
          );
        }
    );
  }

}
