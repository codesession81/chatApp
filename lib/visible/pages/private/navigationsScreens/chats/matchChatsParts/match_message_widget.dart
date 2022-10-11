import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/match_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchMessageWidget extends StatefulWidget {
  final String? senderId;
  final String? senderImage;
  final String? createdAt;
  final String? msgType;
  final bool? isDeleted;
  final MatchMessage message;
  final BuildContext context;
  MatchMessageWidget({required this.senderId,required this.isDeleted,required this.msgType,required this.createdAt,required this.message,required this.context,required this.senderImage});

  @override
  State<MatchMessageWidget> createState() => _MatchMessageWidgetState();
}

class _MatchMessageWidgetState extends State<MatchMessageWidget> {
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.isDeleted==false?Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.createdAt!))):Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.createdAt!)),style: const TextStyle(color: Colors.grey)),
            const SizedBox(width: 20),
          ],
        ),
        widget.senderId==GlobalData.currentUser?.uid?Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widget.isDeleted==false?Padding(
              padding: const EdgeInsets.only(left: 3),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    "${widget.senderImage}"),
              ),
            ):Container(),
            const SizedBox(width: 5),
            buildMessage(),
          ],
        ):Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildMessage(),
            const SizedBox(width: 5),
            widget.isDeleted==false?Padding(
              padding: const EdgeInsets.only(left: 3),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    "${widget.senderImage}"),
              ),
            ):Container(),
          ],
        ),
      ],
    );
  }

  Widget buildMessage() {
    return widget.msgType == "text" ?
    Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(widget.context)
                .size
                .width - 60
        ),
        child: Card(
          color:widget.senderId==GlobalData.currentUser?.uid? Colors.lightGreen[100]:Colors.lightGreen[50],
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 15, top: 5, bottom: 20),
                child: Text(widget.message.message.toString(),),
              ),
              Positioned(
                bottom: 4,
                right: 1,
                child: Row(
                  children: <Widget>[
                    widget.isDeleted == false
                        ? Text(DateFormat('HH:mm').format(
                        DateTime.parse(widget.createdAt!)),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),)
                        : Text(DateFormat('HH:mm').format(
                        DateTime.parse(widget.createdAt!)),
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 2,),
                    //const Icon(Icons.done_all, size: 17,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ) :Container();
  }
}

