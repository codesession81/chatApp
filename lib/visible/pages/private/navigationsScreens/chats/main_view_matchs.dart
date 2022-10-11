import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/offline/cache.dart';
import 'package:example/data/database/online/db_match.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/match_message.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/pages/private/navigationsScreens/chats/matchChatsParts/match_conversation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainViewChats extends StatefulWidget {
  final String? currentUserId;
  MainViewChats(this.currentUserId);

  @override
  _MainViewChatsState createState() => _MainViewChatsState();
}

class _MainViewChatsState extends State<MainViewChats> {
  final DbMatch _dbMatch = DbMatch();
  List<MatchMessage> receiverMessagesList = [];
  List<Match> _matchList = [];
  Member? currentUser;
  bool isCurrentUserBlocked = false;
  bool? informCurrentUserIsBlocked;

 

  @override
  Widget build(BuildContext context) {
    final currentUserMatchList = Provider.of<List<Match>>(context);
    Cache.loadingCurrentUserMatchsStreamInLocalDb(currentUserMatchList);

    return Scaffold(
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box(HiveBoxes.matchsBox).listenable(),
        builder: (context,box,_){
            _matchList = box.values.toList().cast<Match>();
            return _matchList.isNotEmpty==true?ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _matchList.length,
              itemBuilder: (context, index){
                return Container(
                  padding:const EdgeInsets.all(10),
                  height: 75,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchConversation(msgReceived: true,username: _matchList[index].username,profilImageURl: _matchList[index].profilImageURl,chatId: _matchList[index].chatId,empfaengerUid: _matchList[index].uid,currentUserId: GlobalData.currentUser?.uid)));
                    },
                    onLongPress: ()async{
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Match mit ${_matchList[index].username} löschen und dauerhaft blockieren?"),
                            actions: [
                              TextButton(
                                child: const Text("Ja,bitte"),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("Abbrechen"),
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child:Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              isCurrentUserBlocked?const Icon(Icons.person):
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                    _matchList[index].profilImageURl!
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: <Widget>[
                                        isCurrentUserBlocked?Container(): Container(
                                          child:  Text(
                                              _matchList[index].username!,
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                        const SizedBox(width:5 ),
                                        _matchList[index].counterNewMatchMsg == 0 ? const Text("") : Container(
                                          padding:const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          constraints:const BoxConstraints(
                                            minWidth: 20,
                                            minHeight: 20,
                                          ),
                                          child: Text(
                                            _matchList[index].counterNewMatchMsg.toString(),
                                            style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child:_matchList[index].createdAt==""?const Text(""): Text(DateFormat("dd.MM.yyyy").format(DateTime.parse(_matchList[index].createdAt.toString()))),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              isCurrentUserBlocked?const Text("Nix"):
                              Row(
                                children: <Widget>[
                                  _matchList[index].message==""
                                      ? const Text("Keine Unterhaltung vorhanden")
                                      : Flexible(
                                    child: Text(
                                        _matchList[index].message.toString().length>40?_matchList[index].message.toString().substring(0,40)+'...':_matchList[index].message.toString(),
                                        style:  _matchList[index].counterNewMatchMsg != 0 ?const TextStyle(
                                            fontWeight: FontWeight.bold): null),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ),
                );
              }
            ):Center(child: Text("Keine Unterhaltungen"));
        },
      ),
    );
  }
}
