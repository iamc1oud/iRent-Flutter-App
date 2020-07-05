import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rent_app/authorization/firebase_interface.dart';

class FirebaseRepository extends FirebaseHandlers {

  static FirebaseAuth firebaseAuth;

  FirebaseRepository() {
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Future<void> loginUser({String email, String password}) async{
    AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print((await firebaseAuth.isSignInWithEmailLink(email)).toString());
  }

  @override
  Future<void> registerUser({String firstName, String lastName, String email, String password}) async{
    /*`ERROR_WEAK_PASSWORD` - If the password is not strong enough.
    `ERROR_INVALID_EMAIL` - If the email address is malformed.
    `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.*/

    try{
      final FirebaseUser user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;


      /* Update firebase database
    Required fields:
      - Firstname
      - Lastname
      - Email
    */

      Firestore.instance.collection("user").document().setData({
        "firstname" : firstName,
        "lastname" : lastName,
        "email" : email,
        "uid" : user.uid
      });
    } catch(e){
      switch(e.code){
        case "ERROR_WEAK_PASSWORD":
          print("Weak password");
          break;

        case "ERROR_INVALID_EMAIL":
          print("Invalid email");
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          print("Already in use");
          break;
      }
    }
  }
}