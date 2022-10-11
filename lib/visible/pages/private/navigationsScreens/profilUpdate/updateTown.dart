import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/data/database/online/db_update_profile_data.dart';
import 'package:example/data/lists/registration/town.dart';
import 'package:example/data/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class UpdateTown extends StatefulWidget {
  final Member? currentUser;
  UpdateTown(this.currentUser);

  @override
  _UpdateTownState createState() => _UpdateTownState();
}

class _UpdateTownState extends State<UpdateTown> {
  var _searchTownController = new TextEditingController();
  final GlobalKey<FormState> _updateTownFormKey = GlobalKey<FormState>();
  DbUpdateProfileData _dbUpdateProfileData = DbUpdateProfileData();
  String? selectedtown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Form(
          key: _updateTownFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              SizedBox(height: 50.0),
              Center(child: Text("In der Nähe welcher Stadt wohnst Du?",style:TextStyle(color: Colors.lightGreen))),
              TypeAheadFormField<String?>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchTownController,
                  decoration: InputDecoration(
                    labelText: widget.currentUser?.town==""?"Gib Deinen neuen Wohnort ein":widget.currentUser?.town,
                  ),
                ),
                suggestionsCallback: (item)async{
                  return townSearcher(item);
                },
                itemBuilder: (context, String? suggestion) => ListTile(
                  title: Text(suggestion!),
                ),
                onSuggestionSelected: (String? suggestion) =>
                _searchTownController.text = suggestion!,
                validator: (value) =>
                value != null && value.isEmpty ? ErrorFields.requiredField : null,
                onSaved: (value) => selectedtown = value,
              ),
              TextButton(
                onPressed: ()async{
                  final form = _updateTownFormKey.currentState;
                  if(form!.validate()){
                    form.save();
                    await _dbUpdateProfileData.updateTown(town: selectedtown);
                    Navigator.pop(context);
                  }
                },
                child: Text('speichern'),
              )

            ],
          ),
        ),
      ),
    );
  }
  townSearcher(String input){
   return Town.townList.where((item) => item.toLowerCase().contains(input.toLowerCase()));
  }
}
