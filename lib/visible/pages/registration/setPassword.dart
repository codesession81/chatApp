import 'dart:io';

import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/services/authentication/auth_service.dart';
import 'package:example/services/validation/password/is_length_valid.dart';
import 'package:example/services/validation/password/is_pw_empty.dart';
import 'package:example/visible/widgets/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class SetPassword extends StatefulWidget {
  final String? email;
  final String? username;
  final String? gender;
  final String? town;
  final File? file;
  final String? age;
  SetPassword({this.email,this.username,this.file,this.age,this.gender,this.town});

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {

  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final IsPwLengthValid _isPwLengthValid = IsPwLengthValid();
  final IsPwEmpty _isPwEmpty = IsPwEmpty();
  final DateTime _timestamp = DateTime.now();

  String? _password,_confirm_pwd;
  bool loading = false;
  bool isPasswordHidden = true;
  bool isPasswordConfirmHidden = true;
  String? networkStatusMsg ="";
  bool deviceOnline = false;
  bool isPasswordValid = false;
  bool isPasswordConfirmValid = false;

  @override
  Widget build(BuildContext context) {
    return loading? const Loading(): Scaffold(
       appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        title:  const Text("Schritt 7/7",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightGreen),),
      ),
      body: Center(
        child: Form(
          key: _passwordFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "Wähle ein starkes Password",
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child:!isPasswordHidden?Icon(Icons.visibility_off):Icon(Icons.visibility),
                      ),
                    ),
                    validator: (val){
                      if(_isPwEmpty.isPwEmpty(val!)){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isPasswordValid = false;
                          });
                        });
                        return ErrorFields.requiredField;
                      }else if(!_isPwLengthValid.isLengthValid(val)){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isPasswordValid = false;
                          });
                        });
                        return ErrorFields.invalidPwLength;
                      }else{
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          setState(() {
                            isPasswordValid = true;
                            _password = val.trim();
                          });
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: isPasswordConfirmHidden,
                    decoration: InputDecoration(
                      hintText: "Password bestätigen",
                      suffixIcon: InkWell(
                        onTap: _togglePasswordConfirmationView,
                        child:!isPasswordConfirmHidden?Icon(Icons.visibility_off):Icon(Icons.visibility),
                      ),
                    ),
                    validator: (val){
                      if(_isPwEmpty.isPwEmpty(val!)){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isPasswordConfirmValid = false;
                          });
                        });
                        return ErrorFields.requiredField;
                      }else if(!_isPwLengthValid.isLengthValid(val)){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isPasswordConfirmValid = false;
                          });
                        });
                        return ErrorFields.invalidPwLength;
                      }else if(val!=_password){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isPasswordConfirmValid = false;
                          });
                        });
                        return ErrorFields.notEqualPw;
                      }else{
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          setState(() {
                            isPasswordConfirmValid = true;
                            _confirm_pwd = val;
                          });
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () async {
                      if(_passwordFormKey.currentState!.validate()){
                         deviceOnline= await InternetConnectionChecker().hasConnection;
                        if(!deviceOnline){
                          setState(() {
                            networkStatusMsg = "Keine Internetverbindung";
                          });
                          showSimpleNotification(
                            Text("$networkStatusMsg",
                              style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                            background: Colors.red,
                          );
                        }else if(deviceOnline){
                          setState(() {
                            loading = true;
                          });
                        dynamic authResult= await _authService.createUserWithEmailAndPassword(email: widget.email!,username:  widget.username!,file:  widget.file!,password:  _password!,timestamp: _timestamp.toString(),age: widget.age,gender: widget.gender,town: widget.town);
                          if(authResult!=null){
                            setState(() {
                              loading = false;
                            });
                            Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false);
                          }else{
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      }
                    },
                    backgroundColor:isPasswordValid && isPasswordConfirmValid?Colors.lightGreen: Colors.grey,
                    label: const Text("Registrierung abschließen"),
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
      isPasswordHidden = !isPasswordHidden;
    });
  }

  void _togglePasswordConfirmationView(){
    setState(() {
      isPasswordConfirmHidden = !isPasswordConfirmHidden;
    });
  }
}
