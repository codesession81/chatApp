import 'package:example/data/database/offline/cache.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/visible/pages/private/navigationsScreens/chats/main_view_matchs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String? chatId;

  @override
  Widget build(BuildContext context) {
    final currentUserLikesList = Provider.of<List<Like>>(context);
    final currentUserMatchList = Provider.of<List<Match>>(context);
  
    Cache.loadingCurrentUserMatchsStreamInLocalDb(currentUserMatchList);
    Cache.loadingCurrentUserLikesStreamInLocalDb(currentUserLikesList);
    return SafeArea(
          child: DefaultTabController(
          length: 3,
          child: Scaffold(
              body: Column(
                children: <Widget>[
                  TabBar(
                      indicatorColor: Colors.lightGreen,
                      labelColor: Colors.lightGreen,
                      tabs: [
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: <Widget>[
                              const Positioned(
                                child: Tab(
                                  text: 'Matchs',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        MainViewChats(GlobalData.currentUser?.uid),
                      ],
                    ),
                  )
                ],
              )),
          ),
          );
  }
}
