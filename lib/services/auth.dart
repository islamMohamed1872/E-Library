import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 class Userr{
   final String uid;

  Userr({@required this.uid});
 }

 class AuthBase{
   Userr _userFromFirebase(User user ){
    return Userr(uid: user.uid);
   }

   Future<void> registerWithEmailAndPassword(String email, String password) async{
     final authResult =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
   }

   Future<void> loginWithEmailAndPassword(String email, String password) async{
     final authResult =await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     return _userFromFirebase(authResult.user);
   }
   Future<void> logout()async{
     await FirebaseAuth.instance.signOut();
   }
 }