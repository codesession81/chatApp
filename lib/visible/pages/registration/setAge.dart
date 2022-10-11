
import 'package:example/data/consts/errors/error_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'setGender.dart';

class SetAge extends StatefulWidget {
  final String? email;

  SetAge({required this.email});

  @override
  _SetAgeState createState() => _SetAgeState();
}

class _SetAgeState extends State<SetAge> {
  final GlobalKey<FormState> _ageFormKey = GlobalKey<FormState>();
  late String age;
  bool isAgeValid = false;
  bool isFieldEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.lightGreen, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Schritt 2/7",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.lightGreen),
          ),
        ),
        body: Form(
          key: _ageFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 2,
                  decoration:const  InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Dein Alter",
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isFieldEmpty = true;
                        });
                      });
                      return ErrorFields.requiredField;
                    } else if (int.parse(val) < 18) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isAgeValid = false;
                        });
                      });
                      return ErrorFields.invalidAge;
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isAgeValid = true;
                          age = val;
                        });
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height:20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    if (_ageFormKey.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetGender(
                                email: widget.email,
                                age: age,
                              )));
                    }
                  },
                  backgroundColor: isAgeValid ? Colors.lightGreen : Colors.grey,
                  label: const Text("weiter"),
                ),
              ),
            ],
          ),
        ));
  }
}
