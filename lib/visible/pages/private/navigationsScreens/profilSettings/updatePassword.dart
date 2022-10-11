
import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/services/authentication/auth_service.dart';
import 'package:example/services/validation/password/is_length_valid.dart';
import 'package:example/services/validation/password/is_pw_empty.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/profilSettings.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {

  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final IsPwLengthValid _isPwLengthValid = IsPwLengthValid();
  final IsPwEmpty _isPwEmpty = IsPwEmpty();
  final AuthService _authService = AuthService();

  String? _password,_confirm_pwd;
  bool isPasswordHidden = true;
  bool isPasswordConfirmHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Neues Password",style:TextStyle(color: Colors.lightGreen)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
      ),
      body: Center(
        child: Form(
          key: _passwordFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "Wähle ein neues starkes Password",
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child:!isPasswordHidden?Icon(Icons.visibility_off):Icon(Icons.visibility),
                      ),
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
                ),
                SizedBox(height: 50.0),
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
                        return ErrorFields.requiredField;
                      }else if(!_isPwLengthValid.isLengthValid(val)){
                        return ErrorFields.invalidPwLength;
                      }else if(val!=_password){
                        return ErrorFields.notEqualPw;
                      }else{
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          setState(() {
                            _confirm_pwd = val.trim();
                          });
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: ()async{
                    if(_passwordFormKey.currentState!.validate()){
                      await _authService.changePasswordOfCurrentUser(_password!);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilSettings()));
                    }
                  },
                  child: Text('speichern'),
                )
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
