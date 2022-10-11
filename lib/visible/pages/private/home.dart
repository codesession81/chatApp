import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/online/db_login.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'navigationsScreens/chats.dart';
import 'navigationsScreens/members.dart';
import 'navigationsScreens/play_match.dart';
import 'navigationsScreens/profil.dart';

class Home extends StatefulWidget {
  final User? user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DbLogin _dbLogin = DbLogin();

  @override
  void initState() {
    super.initState();
    setOnlineStatusOfCurrentUser();
  }

  void setOnlineStatusOfCurrentUser() async {
    await _dbLogin.setOnlineStatus(widget.user?.uid, 'online');
    await _dbLogin.setLoginDate(widget.user?.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Like>>.value(value: _dbLogin.currentUserLikeList(uid: widget.user?.uid), initialData: []),
        StreamProvider<List<Match>>.value(value: _dbLogin.currentUserMatchList(uid: widget.user?.uid), initialData: []),
      ],
      child:DefaultTabController(
      length: 4,
      child: ValueListenableBuilder<Box>(
        valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
        builder: (context,box,_){
          var listOfAllMembers = box.values.toList().cast<Member>();
          listOfAllMembers.forEach((member) {
            if(member.uid== widget.user?.uid){
              GlobalData.currentUser = member;
            }
          });
          return Scaffold(
              bottomNavigationBar: bottomNavigationMenu(),
              body: TabBarView(
                children: [
                  Members(user: widget.user),
                  PlayMatch(uid: widget.user?.uid),
                  Chats(),
                  Profil()
                ],
              )
          );
        },
      )
    ),
    );
  }

  Widget bottomNavigationMenu(){
    return SizedBox(
      height: 60,
      child: TabBar(
        indicatorColor: Colors.white,
        tabs: [
          const Tab(icon: Icon(Icons.local_fire_department_outlined,color: Colors.lightGreen,size: 30,)),
          const Tab(icon: Icon(Icons.people_outline,color: Colors.lightGreen,size: 30,)),
          Tab(icon:const Icon(Icons.email_outlined,color: Colors.lightGreen,size: 30,)),
          Tab(icon: GlobalData.currentUser?.profilVerified==true?const Icon(Icons.account_circle_outlined,color:Colors.lightGreen,size: 30,):const Icon(Icons.account_circle_outlined,color:Colors.red,size: 30,))
        ],
      ),
    );
  }

}