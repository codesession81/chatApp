
import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/visible/pages/registration/setUsername.dart';
import 'package:flutter/material.dart';

import '../../../../data/lists/registration/gender.dart';

class SetGender extends StatefulWidget {
  final String? email;
  final String? age;
  SetGender({required this.email, required this.age});

  @override
  _SetGenderState createState() => _SetGenderState();
}

class _SetGenderState extends State<SetGender> {
  final GlobalKey<FormState> _setGenderFormKey = GlobalKey<FormState>();
  String gender = "";
  bool isGenderSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Schritt 3/7",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.lightGreen),
        ),
      ),
        body: Form(
      key: _setGenderFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                items: Gender.genderList.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text('$gender'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: gender == "" ? 'Dein Geschlecht?' : gender,
                ),
                validator: (value) {
                  if (value == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isGenderSelected = false;
                      });
                    });
                    return ErrorFields.requiredField;
                  }
                },
                onChanged: (newVal) {
                  setState(() {
                    isGenderSelected = true;
                    gender = newVal!;
                  });
                }),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  if (_setGenderFormKey.currentState!.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetUsername(
                              email: widget.email,
                              age: widget.age,
                              gender: gender,
                            )));
                  }
                },
                backgroundColor: isGenderSelected
                    ? Colors.lightGreen
                    : Colors.grey,
                label: const Text("weiter"),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
