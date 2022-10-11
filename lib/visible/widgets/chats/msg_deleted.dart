import 'package:flutter/material.dart';

class MsgDeleted extends StatefulWidget {
  final String? msg;
  MsgDeleted({required this.msg});

  @override
  State<MsgDeleted> createState() => _MsgDeletedState();
}

class _MsgDeletedState extends State<MsgDeleted> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.97,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${widget.msg}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
        ],
      )
    );
  }
}