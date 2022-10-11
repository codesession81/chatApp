
import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/data/database/online/db_match.dart';
import 'package:example/data/database/online/db_update_profile_data.dart';
import 'package:example/services/validation/email/is_email_empty.dart';
import 'package:example/services/validation/email/is_email_valid.dart';
import 'package:example/services/validation/password/is_length_valid.dart';
import 'package:example/services/validation/password/is_pw_empty.dart';
import 'package:example/visible/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteProfil extends StatefulWidget {
  const DeleteProfil({Key? key}) : super(key: key);

  @override
  State<DeleteProfil> createState() => _DeleteProfilState();
}

class _DeleteProfilState extends State<DeleteProfil> {
  String _email="";
  String _password="";
  bool loading = false;
  bool isHiddenPassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  final GlobalKey<FormState> _deleteProfileKey = GlobalKey<FormState>();
  final IsEmailValid _isEmailValid = IsEmailValid();
  final IsEmailEmpty _isEmailEmpty = IsEmailEmpty();
  final IsPwLengthValid _isPwLengthValid = IsPwLengthValid();
  final IsPwEmpty _isPwEmpty = IsPwEmpty();
  final DbUpdateProfileData _dbUpdateProfileData = DbUpdateProfileData();
  final DbMatch _dbMatch = DbMatch();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Profil löschen",
          style: TextStyle(fontSize: 20, color: Colors.lightGreen),
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0,100.0,15.0,50.0),
          child: Form(
            key: _deleteProfileKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text("Bitte verifiziere Dich zuerst",style: TextStyle(fontSize: 20.0),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 38.0),
                  child: Column(
                    children:<Widget> [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: "Deine Emailadresse",
                        ),
                        validator: (val){
                          if(_isEmailEmpty.isEmailEmpty(val!)){
                            return ErrorFields.requiredField;
                          }else if(!_isEmailValid.isEmailValid(val)){
                            return ErrorFields.inValidEmail;
                          }else{
                            WidgetsBinding.instance.addPostFrameCallback((_){
                              setState(() {
                                _email = val.trim();
                              });
                            });
                          }
                        },
                      ),
                      const SizedBox(height:20.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: isHiddenPassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child:isHiddenPassword?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
                          ),
                          hintText: "Dein Passwort",
                        ),
                        validator: (val){
                          if(_isPwEmpty.isPwEmpty(val!)){
                            return ErrorFields.requiredField;
                          }else if(!_isPwLengthValid.isLengthValid(val)){
                            return ErrorFields.invalidPwLength;
                          }else{
                            WidgetsBinding.instance.addPostFrameCallback((_){
                              setState(() {
                                _password = val.trim();
                              });
                            });
                          }
                        },
                      ),
                      const SizedBox(height:25.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () async {
                            if(_deleteProfileKey.currentState!.validate()) {
                              UserCredential? authResult = await user?.reauthenticateWithCredential(
                                EmailAuthProvider.credential(
                                  email: _email,
                                  password: _password,
                                ),
                              );
                              if(authResult!=null){
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content:
                                        const Text("Profil löschen und alle Daten unwiderruflich löschen?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Ja,Profil und Daten löschen"),
                                            onPressed: () async {
                                             await _dbUpdateProfileData.deleteUser(user);
                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Abbrechen"),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                          backgroundColor: Colors.red,
                          label: const Text('Profil löschen',style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height:25.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView(){
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
