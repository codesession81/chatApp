import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/pages/registration/setTown.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SetUsername extends StatefulWidget {
  final String? age;
  final String? email;
  final String? gender;
  SetUsername({required this.email, required this.age, required this.gender});

  @override
  _SetUsernameState createState() => _SetUsernameState();
}

class _SetUsernameState extends State<SetUsername> {
  String _username = "";
  GlobalKey<FormState> _selectUserNameKey = GlobalKey<FormState>();
  bool isUsernameValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        title:  const Text(
          "Schritt 4/7",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Form(
                          key: _selectUserNameKey,
                          child: ValueListenableBuilder<Box>(
                            valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
                            builder: (context,box,_){
                              var listOfAllMembers = box.values.toList().cast<Member>();
                              List<String?> usernameList=[];
                              listOfAllMembers.forEach((member) {
                                  usernameList.add(member.username);
                              });
                              return TextFormField(
                                maxLength: 20,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: "Wähle einen Nicknamen"),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      setState(() {
                                        isUsernameValid = false;
                                      });
                                    });
                                    return ErrorFields.requiredField;
                                  }  else if (usernameList.contains(val)) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      setState(() {
                                        isUsernameValid = false;
                                      });
                                    });
                                    return ErrorFields.usernameInUse;
                                  }  else {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      setState(() {
                                        isUsernameValid = true;
                                        _username = val.trim();
                                      });
                                    });
                                  }
                                },
                              );
                            },
                          )
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () async {
                            if (_selectUserNameKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SetTown(
                                    email: widget.email,
                                    age: widget.age,
                                    gender: widget.gender,
                                    username: _username,
                                  ),
                                ),
                              );
                            }
                          },
                          backgroundColor:
                              isUsernameValid ? Colors.lightGreen : Colors.grey,
                          label: const Text("weiter"),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
