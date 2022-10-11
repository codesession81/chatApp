import 'package:example/data/consts/msg_categories/msg_categories.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/match_message.dart';
import 'package:example/visible/widgets/chats/msg_deleted.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextMsg extends StatefulWidget {
   final MatchMessage? matchMessage;
   final String msgCategory;
   final String senderId;
   final bool isDeleted;
   final String createdAt;
   TextMsg({required this.createdAt,required this.isDeleted,required this.senderId,required this.msgCategory,this.matchMessage});

  @override
  State<TextMsg> createState() => _TextMsgState();
}

class _TextMsgState extends State<TextMsg> {
  @override
  Widget build(BuildContext context) {
    return widget.isDeleted==false? Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width -60
          ),
          child: Card(
            color:(widget.senderId==GlobalData.currentUser?.uid? Colors.lightGreen[100]:Colors.lightGreen[50]),
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 1,vertical: 5),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 15,top: 5,bottom: 20),
                  child: Text(
                   "${
                    widget.msgCategory==MsgCategories.msgCategoryMatchs?widget.matchMessage?.message.toString():
                    " "}"
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 1,
                  child: Row(
                    children: <Widget>[
                    widget.isDeleted==false?Text(DateFormat('HH:mm').format(DateTime.parse("${ 
                    widget.msgCategory==MsgCategories.msgCategoryMatchs?widget.matchMessage?.createdAt.toString():""
                    }")
                    ),style: TextStyle(fontSize: 13,color: Colors.grey[600]),):Text(DateFormat('HH:mm').format(DateTime.parse("${widget.msgCategory=="match"?widget.matchMessage?.createdAt:""}")),style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 2,),
                    ],
                  ),
                )
              ],
            ),
          ),
          ),
      ):MsgDeleted(msg:widget.msgCategory==MsgCategories.msgCategoryMatchs?widget.matchMessage?.message.toString():
                    "");
  }
}