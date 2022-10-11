import 'package:flutter/material.dart';

class TextWithRadius extends StatelessWidget {

  final bool value;
  final String text;

  TextWithRadius(this.text,this.value);

  @override
  Widget build(BuildContext context) {
    return value==true? Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color:Colors.lightGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    )
        :Container();
  }
}
