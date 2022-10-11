import 'dart:io';

import 'package:example/data/database/online/db_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DbRegistration _dbRegistration = DbRegistration();

  Future createUserWithEmailAndPassword({String? email,String? username,File? file,String? password,String? timestamp,String? age,String? gender,String? town})async{
   try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
      final User? user = userCredential.user;
      _dbRegistration.uploadProfilImageToFirebaseStorage(userId: user!.uid,email: email,username: username,file: file,timestamp: timestamp,age: age,gender: gender,town: town);
      return user;
    }catch(error){
      print(error.toString());
      return null;
    }
  }
  

  Future signInWithEmailAndPassword({String? email,String? password})async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email!,password: password!);
      User? user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Stream<User?> get user => _auth.authStateChanges();

  Future changeEmailOfCurrentUser(String email,String password,String? userId)async{
    var message;
    try{
     User? user = _auth.currentUser;
     _dbRegistration.updateCurrentUserEmail(userId!, email);
     user!.updateEmail(email).then(
           (value) => message = 'Erfolgreich Success',
     ).catchError((onError) => message = 'Fehler error');
     print(message);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future changePasswordOfCurrentUser(String password)async{
    var message;
    try{
      User? user = _auth.currentUser;
      user!.updatePassword(password).then(
            (value) => message = 'Erfolgreich Success',
      ).catchError((onError) => message = 'Fehler error');
      print(message);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  Future requestAccessData(String email)async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(error){
      print(error.toString());
    }
  }

  Future logout()async{
    try{
      return await _auth.signOut();
    }catch(error){
      print(error.toString());
    }
  }

  Future deleteUser()async{
    try{
      User? user = _auth.currentUser;
      user!.delete();
    }catch(e){
      print("Fehler beim Löschen des Users: ${e.toString()}");
    }
  }
}