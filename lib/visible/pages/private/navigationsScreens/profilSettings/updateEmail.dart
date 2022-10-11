import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/services/authentication/auth_service.dart';
import 'package:example/services/validation/email/is_email_empty.dart';
import 'package:example/services/validation/email/is_email_valid.dart';
import 'package:example/services/validation/password/is_length_valid.dart';
import 'package:example/services/validation/password/is_pw_empty.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/profilSettings.dart';
import 'package:example/visible/widgets/loading/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateEmail extends StatefulWidget {
  @override
  _UpdateEmailState createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {

  String? _old_email,_new_email,_confirm_new_email;
  String? _password;

  final GlobalKey<FormState> _setEmailFormKey = GlobalKey<FormState>();
  final CollectionReference _memberRef = FirebaseFirestore.instance.collection('members');
  final IsEmailValid _isEmailValid = IsEmailValid();
  final IsEmailEmpty _isEmailEmpty = IsEmailEmpty();
  final IsPwLengthValid _isPwLengthValid = IsPwLengthValid();
  final IsPwEmpty _isPwEmpty = IsPwEmpty();
  final AuthService _authService = AuthService();
  User? user;

  @override
  void initState() {
    super.initState();
    initCurrentUser();
  }

  void initCurrentUser() async{
    user =FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Emailadresse aktualisieren",style:TextStyle(color: Colors.lightGreen)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
      ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: _memberRef.snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Loading();
                }else{
                  List<String> emailList= snapshot.data!.docs.map((doc) => doc['email'].toString()).toList();
                  return Form(
                    key: _setEmailFormKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget> [
                            SizedBox(height: 50.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: "Alte Emailadresse",
                              ),
                              validator: (val){
                                if(_isEmailEmpty.isEmailEmpty(val!)){
                                  return ErrorFields.requiredField;
                                }else if(!_isEmailValid.isEmailValid(val)){
                                  return ErrorFields.inValidEmail;
                                }else if(user!.email!=val){
                                  return ErrorFields.emailNotMatchAccount;
                                }else{
                                  WidgetsBinding.instance.addPostFrameCallback((_){
                                    setState(() {
                                      _old_email = val.trim();
                                    });
                                  });
                                }
                              },
                            ),
                            const SizedBox(height:20.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: "Neue Emailadresse",
                              ),
                              validator: (val){
                                if(_isEmailEmpty.isEmailEmpty(val!)){
                                  return ErrorFields.requiredField;
                                }else if(!_isEmailValid.isEmailValid(val)){
                                  return ErrorFields.inValidEmail;
                                }else if(emailList.contains(val)){
                                  return ErrorFields.emailInUse;
                                }else{
                                  WidgetsBinding.instance.addPostFrameCallback((_){
                                    setState(() {
                                      _new_email = val.trim();
                                    });
                                  });
                                }
                              },
                            ),
                            const SizedBox(height:20.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: "Emailadresse bestätigen",
                              ),
                              validator: (val){
                                if(_isEmailEmpty.isEmailEmpty(val!)){
                                  return ErrorFields.requiredField;
                                }else if(!_isEmailValid.isEmailValid(val)){
                                  return ErrorFields.inValidEmail;
                                }else if(val!=_new_email){
                                  return ErrorFields.emailsNotEqual;
                                }else{
                                  WidgetsBinding.instance.addPostFrameCallback((_){
                                    setState(() {
                                      _confirm_new_email = val.trim();
                                    });
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "Dein Password",
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
                            SizedBox(height: 25.0),
                            ElevatedButton(
                              onPressed: (){
                                if(_setEmailFormKey.currentState!.validate()){
                                    _authService.changeEmailOfCurrentUser(_new_email!,_password!,user?.uid);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilSettings()
                                    ),
                                  );
                                }
                              },
                              child: Text('speichern'),
                            ),
                            SizedBox(height: 50.0,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
          ),
        )
    );
  }
}
