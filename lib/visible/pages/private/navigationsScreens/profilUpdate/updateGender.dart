import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/data/database/online/db_update_profile_data.dart';
import 'package:example/data/lists/registration/gender.dart';
import 'package:example/data/models/member.dart';
import 'package:flutter/material.dart';

class UpdateGenderState extends StatefulWidget {
  final Member? currentUser;
  UpdateGenderState(this.currentUser);

  @override
  _UpdateGenderStateState createState() => _UpdateGenderStateState();
}

class _UpdateGenderStateState extends State<UpdateGenderState> {
  final DbUpdateProfileData _dbUpdateProfileData = DbUpdateProfileData();
  final GlobalKey<FormState> _updateGenderFormKey = GlobalKey<FormState>();
  String? gender;

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
        body: Form(
          key: _updateGenderFormKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Mit welchen Geschlecht identifizierst Du Dich?",style:TextStyle(color: Colors.lightGreen)),
                ),
                DropdownButtonFormField<String>(
                    items: Gender.genderList.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text('$gender'),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: widget.currentUser?.gender==""?'Keine Auswahl':widget.currentUser?.gender,
                    ),
                    validator: (value) => value == null ? ErrorFields.requiredField : null,
                    onChanged: (newVal) {
                      setState(() {
                        gender = newVal;
                      });
                    }),
                TextButton(
                  onPressed: ()async{
                   if(_updateGenderFormKey.currentState!.validate()){
                    await _dbUpdateProfileData.updateGender(gender: gender);
                    Navigator.pop(context);
                   }
                  },
                  child: Text('Speichern'),
                )
              ],
            ),
          ),
        )
    );
  }
}
