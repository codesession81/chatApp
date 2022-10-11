import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/member.dart';
import '../../services/authentication/auth_service.dart';
import '../../services/validation/email/is_email_empty.dart';
import '../../services/validation/email/is_email_unkown.dart';
import '../../services/validation/email/is_email_valid.dart';
import '../../services/validation/password/is_length_valid.dart';
import '../../services/validation/password/is_pw_empty.dart';
import '../widgets/loading/loading.dart';
import 'private/home.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";
  bool loading = false;
  bool isHiddenPassword = true;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _loginInKey = GlobalKey<FormState>();
  final IsEmailValid _isEmailValid = IsEmailValid();
  final IsEmailEmpty _isEmailEmpty = IsEmailEmpty();
  final IsPwLengthValid _isPwLengthValid = IsPwLengthValid();
  final IsPwEmpty _isPwEmpty = IsPwEmpty();
  final IsEmailUnkwown _emailUnkwown = IsEmailUnkwown();

  @override
  Widget build(BuildContext context) {
    return loading?const Loading(): Scaffold(
      body: Form(
        key: _loginInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "ChatApp",
              style: TextStyle(fontSize: 40.0, color: Colors.lightGreen,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            ValueListenableBuilder<Box>(
                valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
                builder: (context,box,_){
                  var listOfAllMembers = box.values.toList().cast<Member>();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: "Deine Emailadresse",
                      ),
                      validator: (val) {
                        if (_isEmailEmpty.isEmailEmpty(val!)) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isEmailValid = false;
                            });
                          });
                          return ErrorFields.requiredField;
                        } else if (!_isEmailValid.isEmailValid(val)) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isEmailValid = false;
                            });
                          });
                          return ErrorFields.inValidEmail;
                        } else if(!_emailUnkwown.isEmailUnknown(listOfAllMembers, val)){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isEmailValid = false;
                            });
                          });
                          return ErrorFields.unkownEmail;
                        }else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isEmailValid = true;
                              _email = val.trim();
                            });
                          });
                        }
                      },
                    ),
                  );
                }
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                keyboardType: TextInputType.text,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: _togglePasswordView,
                    child: isHiddenPassword
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                  hintText: "Dein Passwort",
                ),
                validator: (val) {
                  if (_isPwEmpty.isPwEmpty(val!)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isPasswordValid = false;
                      });
                    });
                    return ErrorFields.requiredField;
                  } else if (!_isPwLengthValid.isLengthValid(val)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isPasswordValid = false;
                      });
                    });
                    return ErrorFields.invalidPwLength;
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isPasswordValid = true;
                        _password = val.trim();
                      });
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  if (_loginInKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _authService.signInWithEmailAndPassword(email: _email, password: _password);
                    if (result != null) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Home(result),
                      ),
                      );
                    } else {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                backgroundColor: isEmailValid && isPasswordValid
                    ? Colors.lightGreen
                    : Colors.grey,
                label: const Text('Login'),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
