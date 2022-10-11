import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/database/online/db_match.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/match_message.dart';
import 'package:example/visible/pages/private/navigationsScreens/chats/matchChatsParts/match_message_widget.dart';
import 'package:example/visible/widgets/loading/loading.dart';
import 'package:flutter/material.dart';

class MatchConversation extends StatefulWidget {
  final String? profilImageURl;
  final String? username;
  final String? chatId;
  final String? empfaengerUid;
  final String? currentUserId;
  final bool? msgReceived;

  MatchConversation({required this.msgReceived,required this.profilImageURl,required this.username,required this.chatId,required this.empfaengerUid,required this.currentUserId});

  @override
  _MatchConversationState createState() => _MatchConversationState();
}

class _MatchConversationState extends State<MatchConversation> {
  final _controller = TextEditingController();
  final DbMatch _dbMatch = DbMatch();
  List<MatchMessage> matchMessagesList = [];
  String msg = '';
  dynamic matchNewMsgCount=0;
  Stream? chatStream;
  Stream? getSelectedUserLikes;
  Stream? getSelectedMatchData;

  @override
  void initState() {
    super.initState();
    getSelectedMatchData = Collections.matchs.doc(widget.empfaengerUid).collection(Collections.matchLists).doc(widget.currentUserId).snapshots();
    chatStream =Collections.chats.doc(widget.chatId).collection(Collections.chatList).orderBy('createdAt', descending: true).snapshots();
    getSelectedMatchData?.forEach((element) {
      setState(() {
        matchNewMsgCount = element['counterNewMatchMsg'];
      });
    });
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    if (_controller.text.isNotEmpty) {
      matchNewMsgCount++;
      print(matchNewMsgCount);
      _dbMatch.uploadMessage(senderID: GlobalData.currentUser?.uid,empfaengerID: widget.empfaengerUid,message: msg,senderProfilImageURl: GlobalData.currentUser?.profilImage, senderUsername: GlobalData.currentUser?.username,chatId: widget.chatId,matchNewMsgCount: matchNewMsgCount);
      _controller.clear();
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leadingWidth: 70,
                leading: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.arrow_back,size: 24,color: Colors.lightGreen,),
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(
                            "${widget.profilImageURl}"),
                      ),

                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${widget.username}", style: const TextStyle(color: Colors.lightGreen)),
                  ],
                ),
              ),
              body:SafeArea(
                child:SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: chatStream,
                    builder: (context,AsyncSnapshot currentUsersnapshot){
                      if(!currentUsersnapshot.hasData){
                        return const Loading();
                      }else{
                        matchMessagesList.clear();
                        currentUsersnapshot.data.docs.forEach((DocumentSnapshot doc){
                          matchMessagesList.add(MatchMessage.fromDocument(doc));
                        });
                        return Column(
                          children: <Widget>[
                            matchMessagesList.isEmpty
                                ? Expanded(
                                  child: const Center(
                                    child: Text("Keine Unterhaltung"),
                                  ),
                                ): Expanded(
                                  child: ListView.builder(
                              physics:const BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: matchMessagesList.length,
                              itemBuilder: (context, index) {
                                  final message = matchMessagesList[index];
                                  return MatchMessageWidget(
                                    senderId: message.senderId,
                                    createdAt: message.createdAt,
                                    senderImage: message.senderProfilImageURl,
                                    msgType: message.msgType,
                                    isDeleted: message.isDeleted,
                                    message: message,
                                    context: context,
                                  );
                              },
                            ),
                                ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -55,
                                      child: Card(
                                        margin: const EdgeInsets.only(left: 2,right: 2,bottom: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                        child: SingleChildScrollView(
                                          child: TextFormField(
                                            controller: _controller,
                                            textCapitalization: TextCapitalization.sentences,
                                            autocorrect: true,
                                            enableSuggestions: true,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 5,
                                            minLines: 1,
                                            textAlignVertical: TextAlignVertical.center,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Schreib etwas nettes...",
                                                suffixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[

                                                  ],
                                                ),
                                                contentPadding: const EdgeInsets.all(5)
                                            ),
                                            onChanged: (value) =>
                                                setState(() {
                                                  msg = value;
                                                }),
                                          ),
                                        ),
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child:
                                    InkWell(
                                      onTap:sendMessage,
                                      child: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 23,
                                          child: Icon(Icons.send,color: Colors.lightGreen,)
                                      ),
                                    )
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),
                )
              )
          );
  }

}
