import 'package:example/data/consts/errors/error_fields.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/consts/text/strings.dart';
import 'package:example/data/models/member.dart';
import 'package:example/services/validation/email/is_email_empty.dart';
import 'package:example/services/validation/email/is_email_valid.dart';
import 'package:example/visible/pages/mainLoginView.dart';
import 'package:example/visible/pages/registration/setAge.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SetEmailAdresse extends StatefulWidget {
  const SetEmailAdresse({super.key});

  @override
  State<SetEmailAdresse> createState() => _SetEmailAdresseState();
}

class _SetEmailAdresseState extends State<SetEmailAdresse> {
  String? _email, _confirm_email;
  final GlobalKey<FormState> _setEmailFormKey = GlobalKey<FormState>();
  final IsEmailValid _isEmailValid = IsEmailValid();
  final IsEmailEmpty _isEmailEmpty = IsEmailEmpty();
  bool isEmailValid = false;
  bool isConfirmedEmailValid = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.lightGreen,
            ),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainLoginView(),
                  ),
                  (route) => false);
            },
          ),
          title: const Text(
            Strings.reg_step1,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.lightGreen),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
          key: _setEmailFormKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
                child: Text(
                  Strings.reg_header,
                  style: TextStyle(fontSize: 20, color: Colors.lightGreen),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ValueListenableBuilder<Box>(
                  valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
                  builder: (context, box, _) {
                    var listOfAllMembers = box.values.toList().cast<Member>();
                    List<String?> emailList = [];
                    listOfAllMembers.forEach((member) {
                      emailList.add(member.email);
                    });
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: Strings.reg_hint,
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
                          } else if (emailList.contains(val)) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                isEmailValid = false;
                              });
                            });
                            return ErrorFields.emailInUse;
                          } else {
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
                  }),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Emailadresse bestätigen",
                  ),
                  validator: (val) {
                    if (_isEmailEmpty.isEmailEmpty(val!)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isConfirmedEmailValid = false;
                        });
                      });
                      return ErrorFields.requiredField;
                    } else if (!_isEmailValid.isEmailValid(val)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isConfirmedEmailValid = false;
                        });
                      });
                      return ErrorFields.inValidEmail;
                    } else if (val != _email) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isConfirmedEmailValid = false;
                        });
                      });
                      return ErrorFields.emailsNotEqual;
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isConfirmedEmailValid = true;
                          _confirm_email = val.trim();
                        });
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () async {
                    if (_setEmailFormKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetAge(
                                email: _email)),
                      );
                    }
                  },
                  backgroundColor: isEmailValid && isConfirmedEmailValid
                      ? Colors.lightGreen
                      : Colors.grey,
                  label: const Text("weiter"),
                ),
              ),
            ],
          ),
          ),
        )
      ),
    );
  }
}
