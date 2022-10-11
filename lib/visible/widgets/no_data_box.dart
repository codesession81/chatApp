import 'package:flutter/material.dart';

class NoDataBox extends StatefulWidget {
  final String? label;
  NoDataBox({required this.label});

  @override
  State<NoDataBox> createState() => _NoDataBoxState();
}

class _NoDataBoxState extends State<NoDataBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.label == ""
            ? const Text("Keine Angaben")
            : Text("${widget.label}",
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
