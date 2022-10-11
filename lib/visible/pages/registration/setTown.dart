
import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/visible/pages/registration/setProfilImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../data/lists/registration/town.dart';

class SetTown extends StatefulWidget {
  final String? email;
  final String? age;
  final String? gender;
  final String? username;
  SetTown(
      {required this.email,
      required this.age,
      required this.gender,
      required this.username,
      });

  @override
  _SetTownState createState() => _SetTownState();
}

class _SetTownState extends State<SetTown> {
  var _searchTownController = new TextEditingController();
  final GlobalKey<FormState> _updateTownFormKey = GlobalKey<FormState>();
  String selectedtown = "";
  bool isTownSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text("Schritt 5/7",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _updateTownFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50.0),
              TypeAheadFormField<String?>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchTownController,
                  decoration: const InputDecoration(
                    labelText: "Du wohnst in der Umgebung von?",
                  ),
                ),
                suggestionsCallback: (item) async {
                  return townSearcher(item);
                },
                itemBuilder: (context, String? suggestion) => ListTile(
                  title: Text(suggestion!),
                ),
                onSuggestionSelected: (String? suggestion) {
                      if(suggestion!=null){
                         _searchTownController.text = suggestion;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isTownSelected = true;
                      });
                    });
                      }
                }, 
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isTownSelected = false;
                      });
                    });
                    return ErrorFields.requiredField;
                  }
                },
                onSaved: (value) => selectedtown = value!,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    final form = _updateTownFormKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetProfilImage(
                                email: widget.email,
                                age: widget.age,
                                gender: widget.gender,
                                username: widget.username,
                                town: selectedtown,
                              )));
                    }
                  },
                  backgroundColor:
                      isTownSelected ? Colors.lightGreen : Colors.grey,
                  label: const Text("weiter"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  townSearcher(String input) {
    return Town.townList
        .where((item) => item.toLowerCase().contains(input.toLowerCase()));
  }
}
