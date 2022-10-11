import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String? label;
  final Color? color;
  final String? searchMinAge;
  final String? searchMaxAge;
  ActionButton({required this.label,required this.color,this.searchMinAge,this.searchMaxAge});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      onPressed: () {},
      backgroundColor: widget.color,
      label: widget.label == ""
          ? const Text("Keine Angaben")
          : Text("${widget.label}"),
    );
  }
}
